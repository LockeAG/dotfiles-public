local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-_><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-_><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Helper function to create color gradient
local function create_color_gradient(start_color, end_color, steps)
  local sr, sg, sb =
    tonumber(start_color:sub(2, 3), 16), tonumber(start_color:sub(4, 5), 16), tonumber(start_color:sub(6, 7), 16)
  local er, eg, eb =
    tonumber(end_color:sub(2, 3), 16), tonumber(end_color:sub(4, 5), 16), tonumber(end_color:sub(6, 7), 16)
  local gradient = {}
  for i = 0, steps - 1 do
    local r = math.floor(sr + (er - sr) * i / (steps - 1))
    local g = math.floor(sg + (eg - sg) * i / (steps - 1))
    local b = math.floor(sb + (eb - sb) * i / (steps - 1))
    table.insert(gradient, string.format("#%02X%02X%02X", r, g, b))
  end
  return gradient
end

-- Tokyo Night Storm colors
local background_color = "#24283b" -- Tokyo Night Storm background
local border_color = "#7aa2f7" -- Tokyo Night Storm blue

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-_>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
        width = function()
          return math.floor(vim.o.columns * 0.6)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.6)
        end,
      },
      highlights = {
        Normal = {
          guibg = background_color,
        },
        NormalFloat = {
          link = "Normal",
        },
        FloatBorder = {
          guifg = border_color,
          guibg = background_color,
        },
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end,
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        set_terminal_keymaps()
        -- Create fade-in effect
        local start_color = "#000000" -- Start from black
        local steps = 10
        local gradient = create_color_gradient(start_color, background_color, steps)
        for i, color in ipairs(gradient) do
          vim.defer_fn(function()
            vim.api.nvim_set_hl(0, "TerminalNormal", { bg = color })
            vim.cmd("redraw")
          end, i * 20)
        end
      end,
      on_close = function(term)
        -- Create fade-out effect
        local end_color = "#000000" -- Fade to black
        local steps = 10
        local gradient = create_color_gradient(background_color, end_color, steps)
        for i, color in ipairs(gradient) do
          vim.defer_fn(function()
            vim.api.nvim_set_hl(0, "TerminalNormal", { bg = color })
            vim.cmd("redraw")
          end, i * 20)
        end
      end,
    },
    keys = {
      { "<c-_>", desc = "Toggle terminal" },
      { "<leader><c-_>", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "Send current line to terminal" },
      {
        "<leader><c-_>",
        "<cmd>ToggleTermSendVisualSelection<cr>",
        desc = "Send visual selection to terminal",
        mode = "v",
      },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle float terminal" },
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Toggle vertical terminal" },
    },
  },
}
