<script>
import { Pie } from 'vue-chartjs'
export default {

  extends: Pie,

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
          maintainAspectRatio: true
        }
      }
    }
  },

  mounted() {
    this.renderChart( this.data, this.options )
  }

}
</script>