<script>
import { Doughnut } from 'vue-chartjs'
export default {

  extends: Doughnut,

  props: {
    data: {
      type    : Object,
      required: true
    },
    options: {
      type    : Object,
      required: false,
      default() {
        return {
          responsive         : true,
          maintainAspectRatio: true,
        }
      }
    }
  },

  mounted() {
    this.renderChart( this.data, this.options )
  }

}
</script>