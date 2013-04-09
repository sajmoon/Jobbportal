module App
  class DDagen < Generic
    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      authorize! :list, :ddagen
      haml :"d-dagen/index", layout: :"d-dagen-layout"
    end
  end
end
