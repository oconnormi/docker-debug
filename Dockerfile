FROM ubuntu as builder
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/oconnormi/dotfiles.git /dotfiles
RUN git clone https://github.com/VundleVim/Vundle.vim.git /Vundle.vim
FROM ubuntu
RUN apt-get update && apt-get install -y bash zsh curl dnsutils vim git
RUN useradd debug -m -s /bin/zsh
USER debug
WORKDIR /home/debug
RUN mkdir -p /home/debug/.vim/bundle
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
COPY --from=builder --chown=debug:debug /dotfiles /home/debug/.dotfiles
COPY --from=builder --chown=debug:debug /Vundle.vim /home/debug/.vim/bundle/Vundle.vim
RUN rm -rf /home/debug/.zshrc && /home/debug/.dotfiles/scripts/bootstrap
RUN vim -E -s -c "source /home/debug/.vimrc" -c PluginInstall -c qa
ENTRYPOINT [ "/bin/zsh" ]