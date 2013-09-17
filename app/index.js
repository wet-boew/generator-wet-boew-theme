'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var WetBoewThemeGenerator = module.exports = function WetBoewThemeGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(WetBoewThemeGenerator, yeoman.generators.Base);

WetBoewThemeGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.
  console.log(this.yeoman);

  var prompts = [{
    name: 'themeName',
    message: 'What is the name of the theme you want to create?',
  }];

  this.prompt(prompts, function (props) {
    this.themeName = props.themeName;

    cb();
  }.bind(this));
};

WetBoewThemeGenerator.prototype.app = function app() {
  this.mkdir('site');
  this.mkdir('site/data');
  this.mkdir('site/data/i18n');
  this.mkdir('site/includes');
  this.mkdir('site/layouts');
  this.mkdir('site/pages');

  this.copy('site/data/i18n/en.json', 'site/data/i18n/en.json');
  this.copy('site/data/i18n/en.json', 'site/data/i18n/fr.json');
  this.copy('site/pages/index-en.hbs', 'site/pages/index-en.hbs');
  this.copy('site/pages/index-en.hbs', 'site/pages/index-en.hbs');

  this.mkdir('src');
  this.mkdir('src/assets');
  this.mkdir('src/includes');
  
  this.copy('src/theme.js', 'src/theme.js');
  this.copy('src/theme.scss', 'src/theme.scss');

  var includeFiles = ['_screen', '_screen-xlarge', '_screen-large', '_screen-medium', '_screen-medium-small', '_screen-small', '_screen-xsmall', '_print'];
  var path = 'src/includes/';
  includeFiles.forEach(function (file) {
    file = path + file + ".scss";
    this.copy(file, file);
  }.bind(this));

  this.copy('_package.json', 'package.json');
  this.copy('_bower.json', 'bower.json');
  this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
};

WetBoewThemeGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
  this.copy('bowerrc', '.bowerrc');
};