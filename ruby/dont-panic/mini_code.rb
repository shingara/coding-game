STDOUT.sync=true
nf,w,_,ef,ep,_,_,ne=gets.split(" ").collect{|i| i.to_i}
es={ef => ep}
ne.times{e,p=gets.split(" ");es[e.to_i]=p.to_i}
loop{
c=gets.split(" ")
gd= c[2] == "RIGHT" ? c[1].to_i - 1 < es[c[0].to_i] : c[1].to_i + 1 > (es[c[0].to_i] || 0)
puts ([w-1, 0].include?(c[1].to_i) || !gd)?"BLOCK":"WAIT"
}
