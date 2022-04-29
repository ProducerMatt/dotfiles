# TODO: this is hacky. test for existence of files, etc

ln -s (realpath ~/dotfiles/nvim/init.vim) (realpath ~/.config/nvim)
ln -s (realpath ~/dotfiles/nvim/local_init.vim) (realpath ~/.config/nvim)
ln -s (realpath ~/dotfiles/nvim/local_bundles.vim) (realpath ~/.config/nvim)
