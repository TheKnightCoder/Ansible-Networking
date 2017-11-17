#!/usr/bin/python
import re
import json
from pprint import pprint
from ansible.module_utils.basic import *
from collections import OrderedDict
def compileRegex(match): 
  return re.compile(r'^'+match+'[A-Za-z]*\s?(\d+(\/\d+)*)', re.IGNORECASE)
  
def main():
  fields = {
    "interfaces": {"required": True, "type": "list" }
  }
  
  module = AnsibleModule(argument_spec=fields)
  interfaces = module.params['interfaces']

  key = {
    'FastEthernet': compileRegex('Fa'),
    'GigabitEthernet': compileRegex('Gi')
  }
 
  for i in xrange(len(interfaces)):
    for intName, regex in key.iteritems():
      interfaces[i]['INTERFACE'] = regex.sub(intName+r'\1', interfaces[i]['INTERFACE'])

  response = {
    "interfaces": interfaces
  }
 
  module.exit_json(changed=False, **response)
if __name__ == '__main__':  
  main()
