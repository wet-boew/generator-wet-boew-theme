'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var WetBoewThemeGenerator = module.exports = function WetBoewThemeGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'], bower: false });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(WetBoewThemeGenerator, yeoman.generators.Base);

WetBoewThemeGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.
  console.log(this.yeoman);

  var prompts = [
    {
      name: 'themeName',
      message: 'What is the package name of the theme you want to create(ex: theme-wet-boew)?',
    },
    {
      name: 'license',
      message: 'What license do you want to use?',
      default: "MIT"
    }
  ];

  this.prompt(prompts, function (props) {
    this.themeName = props.themeName;

    cb();
  }.bind(this));
};

WetBoewThemeGenerator.prototype.theme = function theme() {
  this.mkdir('site');
  this.mkdir('site/data');
  this.mkdir('site/data/i18n');
  this.mkdir('site/includes');
  this.mkdir('site/layouts');
  this.mkdir('site/pages');

  this.copy('site/data/i18n/en.json', 'site/data/i18n/en.json');
  this.copy('site/data/i18n/en.json', 'site/data/i18n/fr.json');
  this.copy('site/layouts/default.hbs', 'site/layouts/default.hbs');
  this.copy('site/layouts/splashpage.hbs', 'site/layouts/splashpage.hbs');
  this.copy('site/pages/index-en.hbs', 'site/pages/index-en.hbs');
  this.copy('site/pages/index-en.hbs', 'site/pages/index-en.hbs');

  this.mkdir('src');
  this.mkdir('src/assets');
  this.copy('src/assets/favicon.ico', 'src/assets/favicon.ico');
  this.copy('src/assets/favicon-mobile.png', 'src/assets/favicon-mobile.png');
  this.copy('src/assets/logo.svg', 'src/assets/logo.svg');
  this.copy('src/assets/logo.png', 'src/assets/logo.png');

  this.mkdir('src/sass/');
  this.copy('src/sass/theme.scss', 'src/sass/theme.scss');
  this.copy('src/sass/_variables.scss', 'src/sass/_variables.scss');
  this.mkdir('src/sass/views');
  var includeFiles = ['_allScreenViews', '_largeView', '_largeViewOver', '_largeViewUnder', '_mediumView', '_mediumViewOver', '_mediumViewUnder', '_printView', '_smallView', '_smallViewOver', '_smallViewUnder', '_xLargeView', '_xSmallView', '_xSmallViewOver', '_xSmallViewUnder', '_xxSmallView'];
  var path = 'src/sass/views/';
  includeFiles.forEach(function (file) {
    file = path + file + ".scss";
    this.copy(file, file);
  }.bind(this));

  this.mkdir('src/js');
  this.copy('src/js/theme.js', 'src/js/theme.js');

  this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
  this.template('_package.json', 'package.json');
  this.template('_bower.json', 'bower.json');
};

WetBoewThemeGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
  this.copy('bowerrc', '.bowerrc');
};