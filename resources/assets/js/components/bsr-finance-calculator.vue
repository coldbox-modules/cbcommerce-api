<template>
	<div>
		<div class="max-content">
			<label for="amount">Loan Amount</label>
			<div class="form-inline">
				<input type="text" class="form-control form-control-lg" name="amount" id="amount" placeholder="$" v-model="amount" @keyup.enter="calculate()">
				<button type="submit" class="btn btn-secondary btn-lg" @click="calculate()">Calculate</button>
			</div>
		</div>
		<div class="result" v-if="showResult && amount != ''">
			<br/><br/>
			<strong>Amount Leased:</strong> ${{ formattedAmount }}
			<table class="table table-striped">
				<thead>
					<tr>
						<th>Months</th>
						<th>Monthly Payment</th>
						<th>Payment before/at time of order</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="( payment, paymentIdx ) in payments" :key="'payment' + payment.months">
						<td>{{ payment.months }}</td>
						<td>{{ payment.payment }}</td>
						<td>{{ payment.down }} <span v-if="paymentIdx == 0">*</span><span v-else>**</span></td>
					</tr>
				</tbody>
			</table>
			<p>* First payment includes first monthly payment, ${{ docFee }} DOC. FEE and ${{ filingFee }} FILING FEE</p>
			<p>** First payment includes first &amp; last monthly payments, ${{ docFee }} DOC. FEE, and ${{ filingFee }} FILING FEE</p>
			<p>The above monthly payments are based on MONTHLY AUTOMATIC PAYMENTS (ACH).  Other payment methods are subject to prior approval and will have an additional monthly charge. <strong>All leases are subject to approved credit.</strong></p>
		</div>
	</div>
</template>
<script>
	export default{
		data() {
	        return {
	        	showResult: false,
	        	amount: "",
	        	formattedAmount: "",
	        	docFlatFee: 50,
	        	docFeeRate: .005,
	        	filingFee: 10,
	        	payments: []
	        }
	   	},
	   	computed: {
	   		docFee: function(){
	   			if( this.amount > 10000 ){
	   				return this.amount * this.docFeeRate;
	   			} else {
	   				return this.docFlatFee;
	   			}
	   		}
	   	},
	   	methods: {
	   		formatAmount: function(){
	   			if( this.amount != '' && !isNaN( this.amount )){
	   				this.formattedAmount =  Number.parseFloat( this.amount ).toLocaleString()
	   			} else {
	   				this.formattedAmount = 0;
	   			}
	   		},
	   		calculate(){
	   			this.showResult = true;
	   			// format entered amount
	   			this.formatAmount();
	   			// clear any current calculations
	   			this.payments = [];

	   			// calculate
	   			[ 12, 24, 36, 48, 60 ].forEach( length => {
				    this.payments.push( this.calculateFinancing( length ) );
				});

	   		},
	   		calculateFinancing( length ) {
	   			switch( length ){
	   				case 12:
	   					var payment = this.amount*.0915;
	   				break;
	   				case 24:
	   					var payment = this.amount*.05;
	   				break;
	   				case 36:
	   					var payment = this.amount*.0365;
	   				break;
	   				case 48:
	   					var payment = this.amount*.0299;
	   				break;
	   				case 60:
	   					var payment = this.amount*.0262;
	   				break;
	   			}

	   			var formattedPayment = Number.parseFloat( payment ).toFixed(2).toLocaleString();

	   			if( length <= 12 ){
	   				var down = Number.parseFloat( payment + this.docFee + this.filingFee ).toFixed(2).toLocaleString();
	   			} else {
	   				var down = Number.parseFloat( payment * 2 + this.docFee + this.filingFee ).toFixed(2).toLocaleString();
	   			}

	   			return { 'months': length, 'payment': formattedPayment, 'down': down  }
	   		}
	   	}
	}
</script>