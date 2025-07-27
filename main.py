import yaml
import os
import argparse
from jinja2 import Environment, FileSystemLoader

def load_yaml(file_path):
    try:
        with open(file_path, 'r') as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        print(f"Error: Configuration file not found at {file_path}")
        exit(1)
    except yaml.YAMLError as e:
        print(f"Error parsing YAML file {file_path}: {e}")
        exit(1)

def merge_configs(dict1, dict2):
    merged = dict1.copy()
    for key, value in dict2.items():
        if key in merged and isinstance(merged[key], dict) and isinstance(value, dict):
            merged[key] = merge_configs(merged[key], value)
        else:
            merged[key] = value
    return merged

def generate_packer_config(os_name, configs_dir, templates_dir, artifacts_base_dir):
    print(f"\n--- Generating configuration for {os_name.capitalize()} ---")

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

    common_config = load_yaml(file_common_settings)
    os_specific_config = load_yaml(file_os_settings)
    merged_config = merge_configs(common_config, os_specific_config)

    base_env = Environment(loader=FileSystemLoader(templates_dir))
    
    os_artifacts_dir = os.path.join(artifacts_base_dir, os_name)

    name_output_base_pkr_hcl = f'{os_name}.pkr.hcl'
    name_output_variables_pkr_hcl = 'variables.pkr.hcl'

    output_base_pkr_hcl = os.path.join(os_artifacts_dir, name_output_base_pkr_hcl)
    output_variables_pkr_hcl = os.path.join(os_artifacts_dir, name_output_variables_pkr_hcl)

    try:
        template_base = base_env.get_template('base-vbox.pkr.hcl.j2')
        rendered_base = template_base.render(merged_config)
        with open(output_base_pkr_hcl, 'w') as f:
            f.write(rendered_base)
        print(f"  - Generated main Packer config: {name_output_base_pkr_hcl}")
    except Exception as e:
        print(f"  Error rendering base-vbox.pkr.hcl.j2: {e}")

    try:
        template_variables = base_env.get_template('variables-vbox.pkr.hcl.j2')
        rendered_variables = template_variables.render(merged_config)
        with open(output_variables_pkr_hcl, 'w', encoding='utf-8') as f:
            f.write(rendered_variables)
        print(f"  - Generated variables config: {name_output_variables_pkr_hcl}")
    except Exception as e:
        print(f"  Error rendering variables-vbox.pkr.hcl.j2: {e}")

    os_http_dir = os.path.join(os_artifacts_dir, 'http')
    os.makedirs(os_http_dir, exist_ok=True)

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


def main():
    parser = argparse.ArgumentParser(description="Generate Packer configurations for various OSes.")
    parser.add_argument(
        '--all', action='store_true',
        help="Generate configurations for all supported OSes (Ubuntu and Debian)."
    )
    parser.add_argument(
        '--ubuntu', action='store_true',
        help="Generate configuration only for Ubuntu."
    )
    parser.add_argument(
        '--debian', action='store_true',
        help="Generate configuration only for Debian."
    )

    args = parser.parse_args()
    oses_to_generate = []

    if args.all:
        oses_to_generate = ["ubuntu", "debian"]
    elif args.ubuntu:
        oses_to_generate = ["ubuntu"]
    elif args.debian:
        oses_to_generate = ["debian"]
    else:
        parser.parse_args(['-h'])

    base_dir = os.path.dirname(os.path.abspath(__file__))
    configs_dir = os.path.join(base_dir, 'configs')
    templates_dir = os.path.join(base_dir, 'templates')
    artifacts_base_dir = os.path.join(base_dir, 'artifacts')

    os.makedirs(artifacts_base_dir, exist_ok=True)

    for os_name in oses_to_generate:
        generate_packer_config(os_name, configs_dir, templates_dir, artifacts_base_dir)

if __name__ == "__main__":
    main()