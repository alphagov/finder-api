class FinderSignupContentItemPresenter < ContentItemPresenter
  def title
    metadata["name"]
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
      "beta" => metadata.fetch("signup_beta", false),
      "email_signup_choice" => metadata.fetch("email_signup_choice", []),
    }
  end
end
