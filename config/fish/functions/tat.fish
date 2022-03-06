function tat
  set msg (trans :en-en "$argv" --brief)
  echo $msg
  echo $msg | pbcopy
end
