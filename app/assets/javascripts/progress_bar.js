//This code will increment the progress bar per question.
var createProgressBar = function(containerSelector, cellSelector, numberSelector) {
  var $container = $(containerSelector);
  var $cells = $container.find(cellSelector);
  var $number = $container.find(numberSelector);

  var progressBar = {
    filledCount: function() {
      var count = 0;
      for (var i = 0; i < $cells.length ; i++) {
        if ($cells.eq(i).hasClass('filled')) {
          count ++;
        };
      };
      return count;
    },

    setFilledCount: function(n) {
      $cells.removeClass('filled');
      for (var i = 0; i < n; i++) {
        $cells.eq(i).addClass('filled');
      };
      $number.html(n);
    },

    incrementFilledCount: function() {
      var filledCount = this.filledCount();
      this.setFilledCount(filledCount + 1);
    }
  };

  return progressBar;
};


$(document).on('ready', function() {
  if ($('[data-question-info]').length === 0 || $('[data-progress-bar-cell]').length === 0 || $('[data-question-number]').length === 0) {
    return;
  }

  window.ProgressBar = createProgressBar('[data-question-info]', '[data-progress-bar-cell]', '[data-question-number]');
});
