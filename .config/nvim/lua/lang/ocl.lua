-- Define OCL syntax highlighting rules in Lua
vim.cmd [[
  syntax keyword oclKeyword context inv def pre post and or not implies
  syntax match oclOperator "::\\|->\\|=\\|<>\\|<=\\|>=\\|<\\|>"
  syntax match oclComment "--.*$"

  highlight default link oclKeyword Keyword
  highlight default link oclOperator Operator
  highlight default link oclComment Comment
]]
return {}
