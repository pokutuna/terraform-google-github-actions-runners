# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


project_id = attribute('project_id')
mig_name = attribute('mig-name')
service_account_email = attribute('service_account')
mig_instance_template_name= attribute('mig-instance-template')
expected_instances = 2

control "mig" do
    title "MIG"
    describe command("gcloud --project=#{project_id} compute instances list --format=json --filter='#{mig_name}'") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }
      let!(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
          []
        end
      end
    end
end

control "it" do
    title "Instance Template"
    describe command("gcloud --project=#{project_id} compute instance-templates list --format=json --filter='#{mig_instance_template_name}'") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }
    end
end
