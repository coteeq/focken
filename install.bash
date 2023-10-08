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
pip install -U httpx

echo 'Install yandex tools...'
curl -L https://nda.ya.ru/t/Yxq2Yzsq4FQnvL | bash
