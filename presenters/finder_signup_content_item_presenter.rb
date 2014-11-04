class FinderSignupContentItemPresenter < ContentItemPresenter
  def title
    "#{metadata["name"]} email alert subscription"
  end

  def content_id
    metadata["signup_content_id"]
  end

  def base_path
    "/#{metadata["slug"]}/email-signup"
  end

  def description
    metadata["signup_copy"]
  end

  def format
    "finder_email_signup"
  end

  def related
    [metadata["content_id"]]
  end

  def routes
    [
      {
        path: base_path,
        type: "exact",
      }
    ]
  end

  def details
    {
      "email_signup_choice" => metadata["email_signup_choice"],
    }
  end
end
