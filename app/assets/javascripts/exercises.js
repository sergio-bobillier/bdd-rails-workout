$(document).ready(function(){
  $("#workout-date").datepicker({
    dateFormat: 'yy-mm-dd'
  });

  new Morris.Line({
    element: 'chart',  // ID of the element in which to draw the chart
    data: $('#chart').data('workouts'),  // Chart data records. Each element in this array corresponds to a point in the chart
    xkey: 'workout_date',  // The name of the dta record attribute that contains x-values
    ykeys: ['duration_in_min'],  // A list of names of data record attributes that contains y-values
    labels: ['Duration (min)'],  // Labels for the ykeys -- will be displayed when you hover over the chart
    xLabels: ['day'],
    xLabelAngle: 60,
    xLabelFormat: function(x){
      dateString = x.getFullYear() + '/' + parseInt(x.getMonth() + 1) + '/' + x.getDate();
      return dateString;
    },
    yLabelFormat: function(y) {return y + ' min'}
  });
});
