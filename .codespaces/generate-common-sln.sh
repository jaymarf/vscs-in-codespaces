#!/bin/bash

# clear
echo "generate-common-sln running.."

dotnet new sln --force

cascade_sln_root="./cascade/src/VSOnline"
cascade_projects=`dotnet sln $cascade_sln_root/VSOnline.sln list | tail -n +3`
IFS=$'\n'
for project in $cascade_projects
do
    relative_project_path=$(realpath --relative-to=$(pwd) $cascade_sln_root/$project)

    dotnet sln add $relative_project_path
done

vsclk_core_sln_root="./vsclk-core/src/Ide/"
vsclk_core_projects=`dotnet sln $vsclk_core_sln_root/CloudEnvironmentsServices.sln list | tail -n +3`
IFS=$'\n'
for project in $vsclk_core_projects
do
    relative_project_path=$(realpath --relative-to=$(pwd) $vsclk_core_sln_root/$project)

    dotnet sln add $relative_project_path
done
