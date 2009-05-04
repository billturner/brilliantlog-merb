
Factory.define :node do |n|
  n.title 'This is a test node'
  n.content 'And here we have a simple post. A really simple, one line post.'
end

Factory.define :tag do |t|
  t.name 'merb'
end

Factory.define :bookmark do |b|
  b.name 'Google'
  b.url 'http://google.com/'
end