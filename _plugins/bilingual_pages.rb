require "jekyll"

module Jekyll
  class LocalizedCollectionPage < PageWithoutAFile
    def initialize(site, dir, data, content)
      # Keep a Markdown source extension so Jekyll converts member bios and
      # news content before writing the permalink as an HTML index page.
      super(site, site.source, dir, "index.md")
      self.data = data
      self.content = content
    end
  end

  class BilingualPagesGenerator < Generator
    safe true
    priority :high

    LANGUAGES = {
      "en" => { "code" => "en", "root" => "/en/" },
      "zh" => { "code" => "zh-CN", "root" => "/zh/" },
    }.freeze

    def generate(site)
      generate_members(site)
      generate_posts(site)
      validate_translation_pairs(site)
    end

    private

    def generate_members(site)
      translations = site.data.fetch("members_zh", {})
      members = site.collections.fetch("members").docs

      missing = members.reject { |member| translations.key?(member.slug) }.map(&:slug)
      raise "Missing Chinese member translations: #{missing.join(', ')}" unless missing.empty?

      members.each do |member|
        zh = translations.fetch(member.data.fetch("slug", member.slug), translations.fetch(member.slug, {}))

        LANGUAGES.each_key do |lang|
          localized_name = lang == "zh" ? zh.fetch("name", member.data["name"]) : member.data["name"]
          content = lang == "zh" ? zh.fetch("bio", member.content) : member.content
          dir = File.join(lang, "team", member.slug)
          alternate_lang = lang == "en" ? "zh" : "en"

          data = member.data.dup.merge(
            "layout" => "member",
            "lang" => lang,
            "lang_code" => LANGUAGES.fetch(lang).fetch("code"),
            "name" => localized_name,
            "title" => localized_name,
            "member_slug" => member.slug,
            "translation_key" => "member-#{member.slug}",
            "permalink" => "/#{dir}/",
            "alternate_url" => "/#{alternate_lang}/team/#{member.slug}/",
            "sitemap" => true
          )

          site.pages << LocalizedCollectionPage.new(site, dir, data, content)
        end

        site.pages << redirect_page(site, member.url, "/en/team/#{member.slug}/")
      end
    end

    def generate_posts(site)
      translations = site.data.fetch("posts_zh", {})
      posts = site.posts.docs.sort_by(&:date)

      missing = posts.reject { |post| translations.key?(post.slug) }.map(&:slug)
      raise "Missing Chinese post translations: #{missing.join(', ')}" unless missing.empty?

      posts.each_with_index do |post, index|
        zh = translations.fetch(post.slug, {})

        LANGUAGES.each_key do |lang|
          localized_title = lang == "zh" ? zh.fetch("title", post.data["title"]) : post.data["title"]
          localized_tags = lang == "zh" ? zh.fetch("tags", post.data["tags"]) : post.data["tags"]
          content = lang == "zh" ? zh.fetch("content", post.content) : post.content
          year = post.date.strftime("%Y")
          dir = File.join(lang, "blog", year, post.slug)
          alternate_lang = lang == "en" ? "zh" : "en"

          previous_post = index.positive? ? posts[index - 1] : nil
          next_post = index < posts.length - 1 ? posts[index + 1] : nil

          data = post.data.dup.merge(
            "layout" => "post",
            "lang" => lang,
            "lang_code" => LANGUAGES.fetch(lang).fetch("code"),
            "title" => localized_title,
            "tags" => localized_tags,
            "post_slug" => post.slug,
            "translation_key" => "post-#{post.slug}",
            "permalink" => "/#{dir}/",
            "alternate_url" => "/#{alternate_lang}/blog/#{year}/#{post.slug}/",
            "localized_previous" => localized_post_reference(previous_post, lang, translations),
            "localized_next" => localized_post_reference(next_post, lang, translations),
            "sitemap" => true
          )

          site.pages << LocalizedCollectionPage.new(site, dir, data, content)
        end

        site.pages << redirect_page(site, post.url, "/en/blog/#{post.date.strftime('%Y')}/#{post.slug}/")
      end
    end

    def localized_post_reference(post, lang, translations)
      return nil unless post

      zh = translations.fetch(post.slug, {})
      title = lang == "zh" ? zh.fetch("title", post.data["title"]) : post.data["title"]
      {
        "title" => title,
        "url" => "/#{lang}/blog/#{post.date.strftime('%Y')}/#{post.slug}/"
      }
    end

    def redirect_page(site, old_url, destination)
      path = old_url.to_s.sub(%r{^/}, "")
      dir = File.dirname(path)
      name = File.basename(path)
      if name == "." || name.empty?
        dir = path
        name = "index.html"
      elsif File.extname(name).empty?
        dir = path
        name = "index.html"
      end

      page = PageWithoutAFile.new(site, site.source, dir, name)
      page.data = {
        "layout" => "redirect",
        "redirect_to" => destination,
        "permalink" => old_url,
        "sitemap" => false
      }
      page.content = ""
      page
    end

    def validate_translation_pairs(site)
      pairs = site.pages
        .select { |page| page.data["translation_key"] }
        .group_by { |page| page.data["translation_key"] }

      invalid = pairs.map do |key, pages|
        languages = pages.map { |page| page.data["lang"] }.compact.uniq.sort
        key unless languages == LANGUAGES.keys.sort
      end.compact

      raise "Incomplete bilingual page pairs: #{invalid.join(', ')}" unless invalid.empty?
    end
  end
end
