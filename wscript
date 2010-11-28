APPNAME = 'basset'
VERSION = '0.0.1'

srcdir = '.'
blddir = 'build'

def set_options(opt):
  opt.tool_options('compiler_cxx')

def configure(conf):
  conf.check_tool('compiler_cxx')

def build(bld):
  bld(features = 'cxx cprogram',
      souce = ['eval/topic_groups.cpp', 'src/parser.cpp'],
      target = 'bin/topic_groups')

def shutdown(ctx):
  print "shutdown"

