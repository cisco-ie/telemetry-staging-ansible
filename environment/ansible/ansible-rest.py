import os
import sys
from collections import namedtuple
from ansible.parsing.dataloader import DataLoader
from ansible.vars import VariableManager
from ansible.inventory import Inventory
from ansible.executor.playbook_executor import PlaybookExecutor
from flask import Flask, jsonify
from flask_restful import reqparse, abort, Api, Resource

empty = ''

app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()
parser.add_argument('stage', type=str)


class ExecuteAnsiblePlaybooks(Resource):
    def post(self):
        args = parser.parse_args()
        stage = str(args['stage']) + ".yml"
        variable_manager = VariableManager()
        loader = DataLoader()
        inventory = Inventory(loader=loader, variable_manager=variable_manager, host_list='ansible_hosts')
        playbook_path = stage
        if not os.path.exists(playbook_path):
            print '[INFO] The playbook does not exist'
            sys.exit()

        Options = namedtuple('Options',
                             ['listtags', 'listtasks', 'listhosts', 'syntax', 'connection', 'module_path', 'forks',
                              'remote_user', 'private_key_file', 'ssh_common_args', 'ssh_extra_args', 'sftp_extra_args',
                              'scp_extra_args', 'become', 'become_method', 'become_user', 'verbosity', 'check'])
        options = Options(listtags=False, listtasks=False, listhosts=False, syntax=False, connection='ssh',
                          module_path=None, forks=100, remote_user='SR_Ansible', private_key_file=None,
                          ssh_common_args=None, ssh_extra_args=None, sftp_extra_args=None, scp_extra_args=None,
                          become=False, become_method="sudo", become_user='root', verbosity=None, check=False)

        variable_manager.extra_vars = {}  # This can accomodate various other command line arguments.`

        passwords = {}
        pbex = PlaybookExecutor(playbooks=[playbook_path], inventory=inventory, variable_manager=variable_manager,
                                loader=loader, options=options, passwords=passwords)

        results = pbex.run()
        print(isinstance(results, list))
        if results == 0:
            return {"status": "success"}, 200
        else:
            return {"status": "error"}, 500


api.add_resource(ExecuteAnsiblePlaybooks, '/execute')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5444, debug=True, threaded=True, use_reloader=False)
