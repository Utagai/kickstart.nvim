local M = {}

function M.airw(opts, instructions)
  local buf = 0
  local start_line = opts.line1 - 1
  local end_line = opts.line2

  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
  local text = table.concat(lines, '\n')

  local output = vim.fn.system {
    'claude',
    '-p',
    string.format(
      'You must convert the following input text:\n%s\nby following the following instructions: %q. Return ONLY the modified input text, and absolutely nothing else. Do not include Markdown code block formatting.',
      text,
      instructions
    ),
  }

  local lines = vim.split(output, '\n', { trimempty = true })

  -- The first and last line may include Markdown code block formatting, so we remove them if present:
  if lines[1]:match '^```' then
    table.remove(lines, 1)
  end
  if lines[#lines]:match '^```' then
    table.remove(lines, #lines)
  end

  vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end

return M
