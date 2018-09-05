HTMLWidgets.widget({

  name: 'fullcalendar',

  type: 'output',

  factory: function(el, width, height) {


    return {

      renderValue: function(x) {
        $(el).fullCalendar( 'destroy' );
        $(el).fullCalendar(x);

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
