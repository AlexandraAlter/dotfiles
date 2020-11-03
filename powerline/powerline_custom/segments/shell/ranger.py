# vim:fileencoding=utf-8:noet

from __future__ import (unicode_literals, division, absolute_import, print_function)

import os

from powerline.lib.unicode import out_u
from powerline.theme import requires_segment_info
from powerline.segments import Segment, with_docstring

@requires_segment_info
def environment(pl, segment_info):
  '''Return the presense of a Ranger instance, and/or the depth level'''
  level_str = segment_info['environ'].get('RANGER_LEVEL', None)
  try:
    level = int(level_str)
    if level == 1:
      contents = 'Ranger'
    else:
      contents = 'Ranger {}'.format(level)
  except ValueError:
    contents = None

  return contents
