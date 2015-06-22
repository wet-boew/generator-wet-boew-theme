#global module:false
module.exports = (grunt) ->

	# Default task.
	@registerTask(
		"default"
		"Default task, that runs the production build"
		[
			"dist"
		]
	)

	@registerTask(
		"dist"
		"Produces the production files"
		[
			"build"
			"assemble"
			"htmlmin"
			"useMinAssets"
		]
	)

	#Alternate External tasks
	@registerTask(
		"debug"
		"Produces unminified files"
		[
			"build"
		]
	)

	@registerTask(
		"build"
		"Produces unminified files"
		[
			"checkDependencies"
			"clean:dist"
			"copy:wetboew"
			"assets"
			"css"
			"js"
		]
	)

	@registerTask(
		"init"
		"Only needed when the repo is first cloned"
		[
			"install-dependencies"
			"hub"
		]
	)

	@registerTask(
		"server"
		"Run the Connect web server for local repo"
		[
			"connect:server:keepalive"
		]
	)

	@registerTask(
		"css"
		"INTERNAL: Compiles Sass and vendor prefixes the result"
		[
			"sass"
			"autoprefixer"
			"usebanner:css"
			"cssmin"
			"cssmin_ie8_clean"
		]
	)

	@registerTask(
		"assets"
		"INTERNAL: Process non-CSS/JS assets to dist"
		[
			"copy:assets"
		]
	)

	@registerTask(
		"js"
		"INTERNAL: Brings in the custom JavaScripts."
		[
			"copy:js"
			"uglify"
		]
	)

	@registerTask(
		"useMinAssets"
		"Replace unmin refrences with the min paths for HTML files"
		() ->
			htmlFiles = grunt.file.expand(
				"dist/**/*.html"
				"!dist/unmin/**/*.html"
			);

			htmlFiles.forEach(
				( file ) ->
					contents = grunt.file.read( file )
					contents = contents.replace( /\.\.\/\//g, "./" )
					contents = contents.replace( /\"(?!https:)([^\"]*)?\.(js|css)\"/g, "\"$1.min.$2\"" )

					grunt.file.write(file, contents);
			);
	)

	@initConfig

		# Metadata.
		pkg: @file.readJSON("package.json")
		jqueryVersion: grunt.file.readJSON("lib/jquery/bower.json")
		jqueryOldIEVersion: grunt.file.readJSON("lib/jquery-oldIE/bower.json")
		banner: "/*!\n * Web Experience Toolkit (WET) / Boîte à outils de l'expérience Web (BOEW)\n * wet-boew.github.io/wet-boew/License-en.html / wet-boew.github.io/wet-boew/Licence-fr.html\n" +
				" * v<%= pkg.version %> - " + "<%= grunt.template.today('yyyy-mm-dd') %>\n *\n */"

		checkDependencies:
			all:
				options:
					npmInstall: false
		clean:
			dist: [ "dist"]

		copy:
			wetboew:
				expand: true
				cwd: "lib/wet-boew/dist"
				src: [
					"**/*.*"
					"!**/theme*.css"
					"!**/favicon*.*"
					"!demos/**/*.*"
					"!unmin/demos/**/*.*"
					"!theme/**/*.*"
					"!unmin/theme/**/*.*"
					"!**/logo.*"
				]
				dest: "dist/"
			assets:
				expand: true
				cwd: "src/assets"
				src: "**/*.*"
				dest: "dist/assets"
			js:
				expand: true
				cwd: "src"
				src: "**/*.js"
				dest: "dist/js"

		sass:
			all:
				expand: true
				cwd: "src/"
				src: "*.scss"
				dest: "dist/css"
				ext: ".css"

		autoprefixer:
			options:
				browsers: [
					"last 2 versions"
					"android >= 2.3"
					"bb >= 7"
					"ff >= 17"
					"ie >= 8"
					"ios 5"
					"opera 12.1"
				]
			modern:
				cwd: "dist/css"
				src: [
					"*.css"
					"!ie8*.css"
				]
				dest: "dist/css"
				expand: true
			oldIE:
				options:
					browsers: [
						"ie 8"
					]
				cwd: "dist/css"
				src: [
					"ie8*.css"
				]
				dest: "dist/css"
				expand: true

		usebanner:
			css:
				options:
					banner: "@charset \"utf-8\";\n<%= banner %>"
				files:
					src: "dist/css/*.*"

		cssmin:
			dist:
				cwd: "dist/css"
				src: [
					"*.css"
				]
				ext: ".min.css"
				dest: "dist/css"
				expand: true

		cssmin_ie8_clean:
			min:
				expand: true
				cwd: "dist/css"
				src: [
					"**/ie8*.min.css"
				]
				dest: "dist/css"

		# Minify
		uglify:
			dist:
				options:
					banner: "<%= banner %>"
				expand: true
				cwd: "src/"
				src: [
					"<%= copy.js.src %>"
				]
				dest: "dist/js/"
				ext: ".min.js"

		assemble:
			options:
				prettify:
					indent: 2
				marked:
					sanitize: false
				production: false
				data: [
					"lib/wet-boew/site/data/**/*.{yml,json}"
					"site/data/**/*.{yml,json}"
				]
				helpers: [
					"lib/wet-boew/site/helpers/helper-*.js"
					"site/helpers/helper-*.js"
				]
				partials: [
					"lib/wet-boew/site/includes/**/*.hbs"
					"site/includes/**/*.hbs"
				]
				layoutdir: "site/layouts"
				layout: "default.hbs"
				environment:
					jqueryVersion: "<%= jqueryVersion.version %>"
					jqueryOldIEVersion: "<%= jqueryOldIEVersion.version %>"
				assets: "dist/"

			demos:
				files: [
						#site
						expand: true
						cwd: "site/pages"
						src: [
							"*.hbs"
						]
						dest: "dist/unmin"
					,
						#plugins
						expand: true
						cwd: "lib/wet-boew/site/pages/demos"
						src: [
							"**/*.hbs"
						]
						dest: "dist/unmin/demos"
					,
						expand: true
						cwd: "lib/wet-boew/src/plugins"
						src: [
							"**/*.hbs"
						]
						dest: "dist/unmin/demos"
					,
						expand: true
						cwd: "lib/wet-boew/src/polyfills"
						src: "**/*.hbs"
						dest: "dist/unmin/demos"
					,
						expand: true
						cwd: "lib/wet-boew/src/other"
						src: "**/*.hbs"
						dest: "dist/unmin/demos"
				]

		htmlmin:
			options:
				collapseWhitespace: true
				preserveLineBreaks: true
				preventAttributesEscaping: true
			all:
				cwd: "dist/unmin"
				src: [
					"**/*.html"
				]
				dest: "dist"
				expand: true

		hub:
			"wet-boew":
				src: [
					"lib/wet-boew/Gruntfile.coffee"
				]
				tasks: [
					"dist"
				]

		"install-dependencies":
			options:
				cwd: "lib/wet-boew"
				failOnError: false
				isDevelopment: true

		connect:
			options:
				port: 8000

			server:
				options:
					base: "dist"
					middleware: (connect, options, middlewares) ->
						middlewares.unshift(connect.compress(
							filter: (req, res) ->
								/json|text|javascript|dart|image\/svg\+xml|application\/x-font-ttf|application\/vnd\.ms-opentype|application\/vnd\.ms-fontobject/.test(res.getHeader('Content-Type'))
						))
						middlewares

	# These plugins provide necessary tasks.
	@loadNpmTasks "assemble"
	@loadNpmTasks "grunt-autoprefixer"
	@loadNpmTasks "grunt-banner"
	@loadNpmTasks "grunt-check-dependencies"
	@loadNpmTasks "grunt-contrib-clean"
	@loadNpmTasks "grunt-contrib-connect"
	@loadNpmTasks "grunt-contrib-copy"
	@loadNpmTasks "grunt-contrib-cssmin"
	@loadNpmTasks "grunt-contrib-jshint"
	@loadNpmTasks "grunt-contrib-htmlmin"
	@loadNpmTasks "grunt-contrib-uglify"
	@loadNpmTasks "grunt-contrib-watch"
	@loadNpmTasks "grunt-cssmin-ie8-clean"
	@loadNpmTasks "grunt-gh-pages"
	@loadNpmTasks "grunt-hub"
	@loadNpmTasks "grunt-install-dependencies"
	@loadNpmTasks "grunt-sass"

	require( "time-grunt" )( grunt )
	@
