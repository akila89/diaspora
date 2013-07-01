class ManifestController < ApplicationController
  
  def index
    
  end
    def sign
        if user_signed_in?
      redirect_to stream_path
    else
      @css_framework = :bootstrap # Hack, port site to one framework
      render file: Rails.root.join("public", "default.html"),
             layout: 'application'
    end
  end

  def verify
  end
end
