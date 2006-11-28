#!/usr/bin/ruby
#

require 'test/unit'

if ARGV.shift=='-i'
  Dir.chdir('regression')
  print `rm -v *.expect`
  print `rename 's/tags$/tags.expect/g' *.tags`
  print `rename 's/TAGS$/TAGS.expect/g' *.TAGS`
  exit
end

# run regression tests

def regression_test basedir,file
  rtags = 'ruby '+basedir+'/bin/rtags'
  datafn = basedir+'/test/regression/'+File.basename(file)
  cmd = "#{rtags} #{file}"
  print `#{cmd} --quiet -f #{datafn}.TAGS`
  print `diff #{datafn}.TAGS.expect #{datafn}.TAGS`
  print `#{cmd} --vi --quiet -f #{datafn}.tags`
  print `diff #{datafn}.tags.expect #{datafn}.tags`
end

$stderr.print "Begin regression tests..."
basedir = File.dirname(__FILE__)+'/..'
files = Dir.glob(File.dirname(__FILE__) + "/data/*")
files.each do | file |
  regression_test basedir,file
end
$stderr.print "\nFinalised regression tests\n"
