$current_date_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
"$current_date_time Start..."


# 1. 定义一些全局变量
$install_to_dir = "D:\green"
$package_from_dir = "packages"

$maven_dir = "apache-maven-3.5.4"
$maven_url = "http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.4/binaries/$maven_dir-bin.zip"
$maven_package = [io.path]::GetFileName($maven_url)


# 1. 创建绿色软件安装目录
if (!(Test-Path -Path "$install_to_dir")) {
  "创建绿色软件安装目录 $install_to_dir"
  New-Item -ItemType "directory" -Path $install_to_dir
} else {
  "绿色软件安装目录 $install_to_dir 已经存在，忽略继续！"
}

# 2. maven
# 2.1. 下载、安装 maven
$m2_home = "$install_to_dir\$maven_dir"
if (!(Test-Path -Path $m2_home)) {
  if (!(Test-Path -Path "$package_from_dir\$maven_package")) {
    "下载 maven 安装包到 $package_from_dir\$maven_package"
    Invoke-WebRequest -Uri $maven_url -OutFile "$package_from_dir\$maven_package"
  }

  "解压 maven 包到目录 $install_to_dir\$maven_dir"
  Expand-Archive -Path $package_from_dir\$maven_package -DestinationPath $install_to_dir
} else {
  "目录 $m2_home 已经存在，忽略安装 maven！"
}
# 2.2. 设置 maven 环境变量
if (!(Test-Path -Path env:M2_HOME)) {
  "设置用户环境变量 M2_HOME=$m2_home"
  [Environment]::SetEnvironmentVariable("M2_HOME", $m2_home, "User")
  $old_path = [Environment]::GetEnvironmentVariable("Path", "User")
  [Environment]::SetEnvironmentVariable("Path", "$old_path;$m2_home\bin", "User")
} else {
  "M2_HOME 环境变量已经存在，忽略不设置！M2_HOME=$env:M2_HOME"
}


$current_date_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
"$current_date_time End"