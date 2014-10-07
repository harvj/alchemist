(function() {

  this.Alchemist = (function(Backbone, Marionette) {

    var app = new Marionette.Application();

    app.addRegions({
      header_region: '#header-region',
      main_region: '#main-region',
      footer_region: '#footer_region'
    });

    app.on('start', function(options) {
      if (Backbone.history) {
        Backbone.history.start();
      }
    });

    return app;

  }(Backbone, Marionette));

}).call(this)
