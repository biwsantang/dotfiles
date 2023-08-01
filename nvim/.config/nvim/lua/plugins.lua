local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

--	use '~/Workspace/dracula.min.nvim/'

	use 'itchyny/lightline.vim'

--	use { 'cideM/yui', commit = '7609844' }

	use 'rktjmp/lush.nvim'

	use {
        'nvim-treesitter/nvim-treesitter',
				run = ':TSUpdate'
    }

  use 'github/copilot.vim'

	use "sindrets/diffview.nvim"

	use "norcalli/nvim-colorizer.lua"
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
