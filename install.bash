if [ ! -e "~/.token/paste" ]; then
    echo "Please get the paste token and paste to ~/.token/paste"
    echo "https://nda.ya.ru/t/iYFw9Pty6o8qqc"
    exit 1
fi

echo 'Install base apt packages...'
sudo apt update
sudo apt install -y zsh build-essentialsoftware-properties-common neovim

echo 'Install geometry...'
git clone https://github.com/geometry-zsh/geometry .geometry.d

echo 'Install dotfiles...'
curl -fsSL https://raw.githubusercontent.com/coteeq/focken/master/.zshrc > ~/.zshrc

echo 'Install rust & cargo...'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh /dev/stdin -y

echo 'Install ohmyzsh...'
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo 'Install ohmyzsh...'
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo 'Install cooler tools...'
cargo install fd-find du-dust ripgrep git-delta bat hexyl exa zoxide
pip install -U pip
pip install -U httpie

function getpaste() {
    if [[ "$1" == https://nda.ya.ru* ]] || [[ "$1" == nda.ya.ru* ]]; then
        paste_url="$(https https://nda.ya.ru/t/vhLhmMOk6o8piM -h | rg Location | sed 's/Location: //g;s/\r//g')"
    else
        paste_url="$1"
    fi
    https --follow --body "$paste_url" "Authorization:OAuth $(cat ~/.token/paste)"
}

echo 'Install yandex tools...'
getpaste https://nda.ya.ru/t/Yxq2Yzsq4FQnvL | bash

echo 'Install yandex zshrc...'
getpaste https://nda.ya.ru/t/vhLhmMOk6o8piM > ~/.zshrc-yandex
