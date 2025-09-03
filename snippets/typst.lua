---@diagnostic disable: undefined-global

return {
  -- math modes
  s({ trig = 'mt', snippetType = 'autosnippet' }, fmta('$<>$ ', { i(1) })),
  s({ trig = 'mmt', snippetType = 'autosnippet' }, fmta('$ <> $', { i(1) })),
  -- Normal tt snippet
  s({ trig = 'tt', snippetType = 'autosnippet' }, fmta('"<>"', { i(1) })),
  -- Special tt after _ or ^
  s(
    { trig = '(%w+)([_^])tt', regTrig = true, snippetType = 'autosnippet' },
    fmta('<><>"<>"', {
      f(function(args, snip)
        return snip.captures[1] -- the word
      end),
      f(function(args, snip)
        return snip.captures[2] -- the _ or ^
      end),
      i(1),
    })
  ),
  s(
    { trig = '(%w+)([_^])-', regTrig = true, snippetType = 'autosnippet' },
    fmta('<><>(-<>)', {
      f(function(args, snip)
        return snip.captures[1] -- the word
      end),
      f(function(args, snip)
        return snip.captures[2] -- the _ or ^
      end),
      i(1),
    })
  ),
  -- fractions
  s({ trig = 'ff', snippetType = 'autosnippet' }, fmta(' frac(<>,<>) ', { i(1), i(2) })),

  s({ trig = 'nff', snippetType = 'autosnippet' }, fmta('- frac(<>,<>) ', { i(1), i(2) })),

  -- exponents
  -- Generalized superscript excluding digits and uppercase letters
  s(
    { trig = '([^%dA-Z])%1', regTrig = true, snippetType = 'autosnippet' },
    fmta('<>^<>', {
      f(function(args, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    {
      condition = function()
        -- Check if we're in a Typst math mode (between $ signs)
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local before_cursor = string.sub(line, 1, col)

        -- Count $ signs before cursor
        local dollar_count = 0
        for _ in string.gmatch(before_cursor, '%$') do
          dollar_count = dollar_count + 1
        end

        -- If odd number of $ before cursor, we're in math mode
        return dollar_count % 2 == 1
      end,
    }
  ),

  -- integrals
  s({ trig = 'bint', snippetType = 'autosnippet' }, fmta(' integral <> dif <> ', { i(1), i(2) })),

  -- nuclear physics
  s({ trig = 'rn', snippetType = 'autosnippet' }, fmta('r_<>', { i(1) })),
  s({ trig = 'k0', snippetType = 'autosnippet' }, fmta('k_0', {})),
  s({ trig = 'keff', snippetType = 'autosnippet' }, fmta('k_#text[eff]', {})),
  s({ trig = 'ist', snippetType = 'autosnippet' }, fmta('$""^<>$<>', { i(1), i(2) })),
  s({ trig = 'nr', snippetType = 'autosnippet' }, fmta('$""^<>$<>$(n,<>)^<>$<>', { i(1), i(2), i(3), i(4), i(5) })),
  s(
    { trig = 'ng', snippetType = 'autosnippet' },
    fmta('$""^<>$<>$(n,gamma)^<>$<>', {
      i(1),
      i(2),
      f(function(args)
        local num = tonumber(args[1][1])
        return num and tostring(num + 1) or ''
      end, { 1 }),
      rep(2),
    })
  ),
}
