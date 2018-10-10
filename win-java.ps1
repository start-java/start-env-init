$current_date_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
"$current_date_time Start..."


# 1. 定义一些全局变量
$install_to_dir = "D:\green"
$package_from_dir = "packages"

$maven_dir = "apache-maven-3.5.4"
$maven_url = "http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.4/binaries/$maven_dir-bin.zip"
$maven_package = [io.path]::GetFileName($maven_url)

# download portable OpenJDK from https://github.com/ojdkbuild/ojdkbuild
$java_dir = "java-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64"
$java_url = "https://github-production-release-asset-2e65be.s3.amazonaws.com/54895694/246e808e-9124-11e8-8327-f220118bc6f7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20181010%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20181010T161421Z&X-Amz-Expires=300&X-Amz-Signature=390c2c6672320741ee5dc3eba1e98a67e4b2612bcd4a3782b9a91c63693efd5d&X-Amz-SignedHeaders=host&actor_id=271488&response-content-disposition=attachment%3B%20filename%3Djava-1.8.0-openjdk-1.8.0.181-1.b13.ojdkbuild.windows.x86_64.zip&response-content-type=application%2Foctet-stream"
$java_package = "$java_dir.zip" #[io.path]::GetFileName($java_url)


# 2. 创建绿色软件安装目录
if (!(Test-Path -Path "$install_to_dir")) {
  "创建绿色软件安装目录 $install_to_dir"
  New-Item -ItemType "directory" -Path $install_to_dir
} else {
  "绿色软件安装目录 $install_to_dir 已经存在，忽略继续！"
}
"-----------------------------"

# 3. java
# 3.1. 下载、安装 java
$java_home = "$install_to_dir\$java_dir"
if (!(Test-Path -Path $java_home)) {
  if (!(Test-Path -Path "$package_from_dir\$java_package")) {
    "下载 java 安装包到 $package_from_dir\$java_package"
    "java_url=$java_url"
    Invoke-WebRequest -Uri $java_url -OutFile "$package_from_dir\$java_package"
  }

  "解压 java 包到目录 $install_to_dir\$java_dir"
  Expand-Archive -Path $package_from_dir\$java_package -DestinationPath $install_to_dir
} else {
  "目录 $java_home 已经存在，忽略安装 java！"
}
# 3.3. 设置 java 环境变量
if (!(Test-Path -Path env:JAVA_HOME)) {
  "设置用户环境变量 JAVA_HOME=$java_home"
  [Environment]::SetEnvironmentVariable("JAVA_HOME", $java_home, "User")
  $old_path = [Environment]::GetEnvironmentVariable("Path", "User")
  [Environment]::SetEnvironmentVariable("Path", "$old_path;$java_home\bin", "User")
} else {
  "JAVA_HOME 环境变量已经存在，忽略不设置！JAVA_HOME=$env:java_HOME"
}
"----------end java ----------"

# 4. maven
# 4.1. 下载、安装 maven
$m2_home = "$install_to_dir\$maven_dir"
if (!(Test-Path -Path $m2_home)) {
  if (!(Test-Path -Path "$package_from_dir\$maven_package")) {
    "下载 maven 安装包到 $package_from_dir\$maven_package"
    "maven_url=$maven_url"
    Invoke-WebRequest -Uri $maven_url -OutFile "$package_from_dir\$maven_package"
  }

  "解压 maven 包到目录 $install_to_dir\$maven_dir"
  Expand-Archive -Path $package_from_dir\$maven_package -DestinationPath $install_to_dir
} else {
  "目录 $m2_home 已经存在，忽略安装 maven！"
}
# 4.2. 设置 maven 环境变量
if (!(Test-Path -Path env:M2_HOME)) {
  "设置用户环境变量 M2_HOME=$m2_home"
  [Environment]::SetEnvironmentVariable("M2_HOME", $m2_home, "User")
  $old_path = [Environment]::GetEnvironmentVariable("Path", "User")
  [Environment]::SetEnvironmentVariable("Path", "$old_path;$m2_home\bin", "User")
} else {
  "M2_HOME 环境变量已经存在，忽略不设置！M2_HOME=$env:M2_HOME"
}
"----------end maven----------"


$current_date_time = Get-Date -format "yyyy-MM-dd HH:mm:ss"
"$current_date_time End"