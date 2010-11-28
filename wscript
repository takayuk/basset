APPNAME = 'test-project'
VERSION = '1.0.0'

top = 'src'
out = 'build'

def options(opt):
  opt.tool_options('compiler_cxx')
  pass

def configure(conf):
  conf.check_tool('compiler_cxx')
  pass

def build(bld):
  bld(features = 'cxx cprogram',
      source = 'eval/topic_groups.cpp',
      target = 'test')
  pass

def shutdown(ctx):
  pass

