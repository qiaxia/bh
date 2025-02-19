installbaohuo() {
  installpath="$HOME"
  local user="$(whoami)"
  local domain="$user.serv00.net"
  domain="${domain,,}"
  local domainPath="${installpath}/domains/$domain/public_nodejs"
  local workdir="${installpath}/baohuo"

  if [[ -e "$domainPath/config.json" ]]; then
    red "已安装,请勿重复安装!"
    return 1
  fi

  cd "$workdir" || { echo "目录 $workdir 不存在"; return 1; }

  read -p "需要使用默认域名[$domain]进行安装，若继续安装将会删除默认域名，确认是否继续? [y/n] [y]:" input
  input=${input:-y}
  if [[ "$input" != "y" ]]; then
    echo "取消安装"
    return 1
  fi

  delDefaultDomain
  echo "正在安装..."
  if ! createDefaultDomain; then
    return 1
  fi

  mv "$domainPath/public" "$domainPath/static"
  cp ./baohuo.jpg "$domainPath/static"
  cp ./config.json "$domainPath"
  cp ./app.js "$domainPath"

  cd "$domainPath" || { echo "无法进入目录 $domainPath"; return 1; }

  if ! command -v npm22 &>/dev/null; then
    npm_cmd="npm"
  else
    npm_cmd="npm22"
  fi

  if ! $npm_cmd install express body-parser child_process fs; then
    red "安装依赖失败"
    return 1
  fi


  read -p "输入保活时间间隔(单位:分钟)[默认:2分钟]:" interval
  interval=${interval:-2}

  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "s/TM/$interval/g" config.json
  else
    sed -i "s/TM/$interval/g" config.json
  fi

  green "安装成功"
}

delDefaultDomain() {
  local user="$(whoami)"
  local domain="$user.serv00.net"
  domain="${domain,,}"
  if ! devil www del "$domain" --remove; then
    red "删除默认域名失败"
    return 1
  fi
}

createDefaultDomain() {
  local user="$(whoami)"
  local domain="$user.serv00.net"
  domain="${domain,,}"
  if ! devil www add "$domain" nodejs /usr/local/bin/node22 production; then
    red "创建默认域名失败"
    return 1
  fi
}
