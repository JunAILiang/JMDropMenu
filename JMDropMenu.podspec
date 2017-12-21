

Pod::Spec.new do |s|

  s.name         = "JMDropMenu"
  s.version      = "0.1.1"
  s.summary      = "仿QQ、微信下拉菜单封装, 一行代码调用"

  s.description  = <<-DESC
  					    仿QQ、微信下拉菜单封装, 一行代码调用
                   DESC

  s.homepage     = "https://github.com/JunAILiang/JMDropMenu"

  s.license      = "MIT"

  s.author             = { "LJM" => "gzliujm@163.com" }

  s.platform	= :ios, "8.0"

  s.source       = { :git => "https://github.com/JunAILiang/JMDropMenu.git", :tag => "#{s.version}" }

  s.source_files  = "JMDropMenu/JMDropMenu/**/*.{h,m}"

  s.requires_arc = true

end
