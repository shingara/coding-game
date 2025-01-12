l=gets.to_i
h=gets.to_i
t=gets.chomp
le={}
h.times{
nb,s,e='a',1,''
gets.chomp.each_char{|c|
e+=c
(le[nb] ||= [];le[nb] << e;e = '';nb.next!)if s%l==0
s+=1
}
}
h.times{|i|
t.each_char{|c|k=c.downcase;print (le.key?(k) ? le[k] : le['aa'])[i]}
print "\n"
}
