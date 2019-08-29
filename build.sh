
# Set NG_CLI_ANALYTICS to disable Angular CLI prompt "Would you like to share anonymous usage data with the Angular Team"
export NG_CLI_ANALYTICS=ci

################################################################################
# Uninstall
npm uninstall -g angular/cli
npm uninstall angular-cli --save-dev
rm -rf node_modules dist
npm cache clean --force
npm audit fix

################################################################################
# Install
npm install

################################################################################
# To update to a new major version all the packages, install the npm-check-updates package globally:
#sudo npm install -g npm-check-updates
#ncu -u       # Upgrade all the version hints in the package.json file, to dependencies and devDependencies
#npm update
#npm install

################################################################################
# Build
ng build

ls -al dist/
