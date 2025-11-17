import yaml
import os
import argparse
from dotenv import load_dotenv
from typing import Any, Dict
from jinja2 import Environment, FileSystemLoader

def init_parse_arg() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate Packer configurations for various OS and hypervisors.")
    
    hypervisor_group = parser.add_mutually_exclusive_group(required=True)
    hypervisor_group.add_argument('--virtualbox', action='store_true', help="Generate configuration for VirtualBox.")
    hypervisor_group.add_argument('--vmware', action='store_true', help="Generate configuration for VMware Workstation.")
    
    os_group = parser.add_mutually_exclusive_group(required=True)
    os_group.add_argument('--all', action='store_true', help="Generate configurations for all supported OSes (Ubuntu and Debian).")
    os_group.add_argument('--ubuntu', action='store_true', help="Generate configuration only for Ubuntu.")
    os_group.add_argument('--debian', action='store_true', help="Generate configuration only for Debian.")

    parser.add_argument('--rootless', action='store_true', help="Generate a rootless image configuration (for testing without root access).")

    return parser.parse_args()

def update_common_config(common_config: dict[str, str], is_rootless: bool):
    load_dotenv()
    
    common_config['ssh_config'].update({"password": os.getenv('PASSWORD')})
    common_config['ssh_config'].update({"private_key_file": os.getenv('PRIVATE_KEY_FILE')})
    common_config['ssh_config'].update({"pub_key": os.getenv('PUBLIC_KEY')})

    if is_rootless:
        common_config['ssh_config'].update({"is_rootless": is_rootless})
        common_config['ssh_config'].update({"username": os.getenv('SUDO_USER')})
    else:
        common_config['ssh_config'].update({"is_rootless": is_rootless})
        common_config['ssh_config'].update({"username": "root"})

def load_yaml(file_path: str) -> Dict[str, Any]:
    try:
        with open(file_path, 'r') as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        print(f"Error: Configuration file not found at {file_path}")
        exit(1)
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file {file_path}: {e}")
        exit(1)

def merge_configs(dict1: Dict[str, any], dict2: Dict[str, any]) -> Dict[str, any]:
    merged = dict1.copy()
    for key, value in dict2.items():
        if key in merged and isinstance(merged[key], dict) and isinstance(value, dict):
            merged[key] = merge_configs(merged[key], value)
        else:
            merged[key] = value
    return merged

def generate_packer_config(os_name: str, is_rootless: bool, hypervisor: str, configs_dir: str, templates_dir: str, artifacts_base_dir: str) -> None:
    print(f"\n--- Generating configuration for {os_name.capitalize()} on {hypervisor.capitalize()} ---")

    os_configs = {
        "ubuntu": {
            "os_config_file": "ubuntu.yaml",
            "provision_templates_dir": "subiquity"
        },
        "debian": {
            "os_config_file": "debian.yaml",
            "provision_templates_dir": "preseed"
        }
    }

    os_info = os_configs[os_name]

    file_common_settings = os.path.join(configs_dir, 'common.yaml')
    file_os_settings = os.path.join(configs_dir, os_info["os_config_file"])
    file_hypervisor_settings = os.path.join(configs_dir, f'{hypervisor}.yaml')

    common_config = load_yaml(file_common_settings)
    update_common_config(common_config, is_rootless)

    os_specific_config = load_yaml(file_os_settings)
    hypervisor_specific_config = load_yaml(file_hypervisor_settings)

    merged_config = merge_configs(common_config, os_specific_config)
    merged_config = merge_configs(merged_config, hypervisor_specific_config)

    base_env = Environment(loader=FileSystemLoader(templates_dir))
    
    os_artifacts_dir = os.path.join(artifacts_base_dir, hypervisor, os_name)
    os.makedirs(os_artifacts_dir, exist_ok=True)

    name_output_base_pkr_hcl = f'{os_name}.pkr.hcl'
    output_base_pkr_hcl = os.path.join(os_artifacts_dir, name_output_base_pkr_hcl)

    os_http_dir = os.path.join(os_artifacts_dir, 'http')
    os.makedirs(os_http_dir, exist_ok=True)

    try:
        template_base_filename = f'base-{hypervisor}.pkr.hcl.j2'
        template_base = base_env.get_template(template_base_filename)
        rendered_base = template_base.render(merged_config)

        with open(output_base_pkr_hcl, 'w') as f:
            f.write(rendered_base)
        print(f"  - Generated main Packer config: {name_output_base_pkr_hcl}")
    except Exception as e:
        print(f"  Error rendering {template_base_filename}: {e}")

    full_provision_templates_dir = os.path.join(templates_dir, os_info["provision_templates_dir"])
    provision_env = Environment(loader=FileSystemLoader(full_provision_templates_dir))

    for filename in os.listdir(full_provision_templates_dir):
        if filename.endswith('.j2'):
            output_filename = filename[:-3]

            try:
                template = provision_env.get_template(filename)
                rendered_content = template.render(merged_config)

                with open(os.path.join(os_http_dir, output_filename), 'w') as f:
                    f.write(rendered_content)  

                print(f"  - Generated provisioning file: {output_filename}")
            except Exception as e:
                print(f"  Error rendering template '{filename}': {e}")

def main() -> None:
    args = init_parse_arg()

    hypervisor = None
    if args.virtualbox:
        hypervisor = "virtualbox"
    elif args.vmware:
        hypervisor = "vmware"

    os_to_generate = []
    if args.all:
        os_to_generate = ["ubuntu", "debian"]
    elif args.ubuntu:
        os_to_generate = ["ubuntu"]
    elif args.debian:
        os_to_generate = ["debian"]

    is_rootless = args.rootless
    base_dir = os.path.dirname(os.path.abspath(__file__))
    configs_dir = os.path.join(base_dir, 'configs')
    templates_dir = os.path.join(base_dir, 'templates')
    artifacts_base_dir = os.path.join(base_dir, 'artifacts')
    
    os.makedirs(artifacts_base_dir, exist_ok=True)

    for os_name in os_to_generate:
        generate_packer_config(os_name, is_rootless, hypervisor, configs_dir, templates_dir, artifacts_base_dir)

if __name__ == "__main__":
    main()