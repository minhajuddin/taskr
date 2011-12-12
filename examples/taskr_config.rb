data_dir "~/.taskr"
list_size 25
priority_regex /[+-]+/ #TODO: should probably be a priority_evaluator?
tag_regex  /(:[a-zA-Z0-9_:-]+)/

tag_transforms({
  (Time.now).strftime(":%Y%m%d") => ':today',
  (Time.now - 24 * 60 * 60).strftime(":%Y%m%d") => ':yesterday',
  (Time.now + 24 * 60 * 60 ).strftime(":%Y%m%d") => ':tomorrow'
})
