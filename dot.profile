
if [ -d $HOME/.local -a -d $HOME/.local/bin ]; then
   export PATH=$HOME/.local/bin:$PATH
fi

eval $(opam env)
