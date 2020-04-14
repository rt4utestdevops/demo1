  var clock;

         $(document).ready(function() {

            // Instantiate a counter
            clock = new FlipClock($('.clock'), {
               clockFace: 'Counter',
               //autoStart: true,
               minimumDigits: 14
            });
         });


         var barge;

         $(document).ready(function() {

            // Instantiate a counter
            barge = new FlipClock($('.barge'), {
               clockFace: 'Counter',
               //autoStart: true,
               minimumDigits: 14
            });
            //clock.setTime(1234568);
         });