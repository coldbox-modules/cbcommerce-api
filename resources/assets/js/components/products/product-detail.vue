<template>
  <div>
    <product-detail-loading v-if="!currentProduct"></product-detail-loading>

    <div class="col-md-12 productDetailHeader" v-if="currentProduct">
      <div class="col-md-1">
        <a href="javascript:window.history.back()"><div class="back-button"></div></a>
      </div>
      <div class="col-md-11">
        <h1
          class="wow fadeInRight animated animated"
          data-wow-duration="1s"
          v-html="currentProduct.name"
        ></h1>
      </div>
    </div>
    <div class="col-md-12 col-lg-12">
      <div class="col-md-9" v-if="activeSku">
        <div class="block-product-detail">
          <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
              <product-images-gallery :media="displayedMedia"></product-images-gallery>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-6 col-lg-6">
              <div class="product-detail-section">
                <div class="product-rating">
                  <star-rating
                    :show-rating="false"
                    :item-size="10"
                    :read-only="true"
                    :rating="currentProduct.reviewSummary.averageRating"
                  ></star-rating>

                  <a
                    href
                    class="review"
                    v-if="currentProduct.reviewSummary.reviewCount"
                  >{{ currentProduct.reviewSummary.reviewCount }} Reviews</a>
                  <span class="review">No Reviews</span>
                </div>

                <div class="clearfix" v-if="activeSku.showPricing">
                  <p class="product-price">{{ activeSku.basePrice | currency }}</p>
                </div>

                <div class="clearfix" v-if="activeSku.showPricing">
                  <label class="pull-left">List Price:</label>
                  <p class="product-list-price">{{ activeSku.MSRP | currency }}</p>
                </div>

                <div class="product-information">
                  <div class="clearfix">
                    <p
                      class="availability"
                      v-bind:class="{ active: isAvailable }"
                    >{{ availabilityText }}</p>
                  </div>

                  <slot
                    name="beforeDetailSnapshot"
                    v-bind:product="currentProduct"
                    v-bind:activeSku="activeSku"
                  ></slot>

                  <div class="clearfix">
                    <label class="pull-left">Brand:</label>
                    {{ currentProduct.manufacturer }}
                  </div>

                  <div v-if="currentProduct.skus.length == 1" class="clearfix">
                    <label class="pull-left">Model:</label>
                    {{ activeSku.modelNumber }}
                  </div>

                  <div v-else class="clearfix">
                    <label>Summary:</label>
                    <p v-if="activeSku.shortDescription" v-html="activeSku.shortDescription"></p>
                    <p v-else v-html="currentProduct.shortDescription"></p>
                  </div>

                  <div v-if="activeSku.condition.name !== 'New'" class="clearfix">
                    <label>Condition:</label>
                    {{activeSku.condition.name}}
                    <span v-if="activeSku.subCondition.name">( {{activeSku.subCondition.name}} )</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div id="model-numbers" v-if="currentProduct.skus.length > 1" class="row sku-options">
            <div
              v-for="sku in currentProduct.skus"
              :class="`sku-option${activeSku.id === sku.id ? ' selected' : ''}`"
              :id="sku.id"
              :key="`sku_select_${sku.id}`"
              @click="selectActiveSku(sku)"
            >
              <div
                v-if="sku.media.length"
                class="pull-left sku-select-img-wrap"
                :style="`background-image: url('${sku.media[0].src}');background-size:cover;`"
              ></div>
              <div class="sku-option-description">
                {{ sku.modelNumber }}
                <span v-if="sku.condition.name !== 'New'">( {{sku.condition.name}} )</span>
              </div>
            </div>
          </div>
        </div>
      </div>

        <div class="col-md-3 col-lg-3 product-detail-sidebar-section">
          <div class="product-information" v-if="!isLoading">
            <div v-if="activeSku.showPricing">
              <quantity-control
                :showLabel="false"
                :maxQuantity="activeSku.allowBackorder ? null : activeSku.onHand"
                v-if="isAvailable"
                v-on:quantityChange="quantityChangeReaction"
              ></quantity-control>

              <div class="product-cart-total-price clearfix">
                <label class="pull-left">Total:</label>
                <p>{{cartTotalPrice | currency}}</p>
              </div>

              <div v-if="isAvailable" class="shopping-cart-buttons">
                <a
                  @click="addItemToCart( { sku: activeSku.id, quantity: chosenQuantity } )"
                  v-tooltip="'Add this item to your cart'"
                  class="addToCart"
                >
                  <i class="fa fa-shopping-cart"></i> Add to cart
                </a>
              </div>
            </div>

            <h3 v-if="!activeSku.showPricing">
              <span class="heading-highlight" v-html="$t('pricing_disabled_message')"></span>
              <br>
              <br>
              <div class="product-request">
                <a
                  href="javascript:;"
                  @click="toggleModal"
                  v-tooltip="'Request a quote for this item'"
                  class="btn btn-lg btn-secondary btn-fluid"
                >
                  <i class="fa fa-envelope"></i> Request quote
                </a>
              </div>
            </h3>

            <div class="shopping-cart-buttons mt-20">
              <wishlist-add-icon :skuId="activeSku.id"></wishlist-add-icon>

              <comparison-add-icon :skuId="activeSku.id"></comparison-add-icon>
            </div>

            <hr>
          </div>
        </div>

      <sku-quote-modal
        v-if="showQuoteModal"
        v-on:quote-modal-close="showQuoteModal=false"
        :skuId="activeSku.id"
      ></sku-quote-modal>

      <!-- tab box -->

      <div class="box-border block-form" v-if="!isLoading">
        <!-- Nav tabs -->
        <ul class="nav nav-pills nav-justified">
          <li class="active">
            <a href="#description" data-toggle="tab">Description</a>
          </li>
          <li>
            <a href="#additional" data-toggle="tab">Additional</a>
          </li>
          <li>
            <a href="#review" data-toggle="tab">Review</a>
          </li>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
          <div class="tab-pane active" id="description">
            <div v-if="activeSku.condition.name !== 'New'">
              <h3>Condition: {{activeSku.condition.name}}</h3>
              <p>{{activeSku.conditionDescription}}</p>
            </div>
            <br>
            <h3>Product Details</h3>
            <hr>
            <p v-html="activeSku.description || currentProduct.description"></p>
          </div>
          <div class="tab-pane" id="additional">
            <br>
            <h3>Additional Details</h3>
            <hr>
            <h4>Specifications:</h4>
            <ul class="list-unstyled">
              <li v-for="spec in activeSku.options" :key="spec.id" class="description">
                <strong>{{spec.name}}:</strong>
                {{ spec.value }}
              </li>
              <li v-if="!activeSku.options.length">
                <em class="text-muted">No product specifications available</em>
              </li>
            </ul>
            <h4>Dimensions</h4>
            <ul>
              <li v-if="activeSku.packagingY">
                <strong>Height:</strong>
                {{activeSku.packagingY}} {{globalData.measurementUnit || 'inches'}}
              </li>

              <li v-if="activeSku.packagingX">
                <strong>Width:</strong>
                {{activeSku.packagingX}} {{globalData.measurementUnit || 'inches'}}
              </li>

              <li v-if="activeSku.packagingZ">
                <strong>Depth:</strong>
                {{activeSku.packagingZ}} {{globalData.measurementUnit || 'inches'}}
              </li>

              <li v-if="activeSku.packagedWeight">
                <strong>Weight:</strong>
                {{activeSku.packagedWeight}} {{globalData.weightUnit || 'pounds'}}
              </li>
            </ul>
          </div>
          <div class="tab-pane" id="review">
            <br>
            <div class="row" v-if="currentProductReviews.length">
              <div class="col-md-12">
                <h3>Reviews</h3>
                <hr>
                <product-review
                  v-for="(review, index) in currentProductReviews"
                  :key="index"
                  :review="review"
                ></product-review>
              </div>
            </div>

            <!-- Product review form -->
            <product-review-form v-if="authUser" v-on:reviewSubmission="reviewSubmissionReaction"></product-review-form>
            <!-- End product review form -->
            <div class="row" v-else>
              <div class="col-xs-12">
                <h3>Sign in to Review This Product</h3>
                <login-form></login-form>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- end tab box -->
      <div class="container">
        <related-product-carousel></related-product-carousel>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions, mapState } from "vuex";
import { StarRating } from "vue-rate-it";
import "ez-plus/src/jquery.ez-plus.js";
import ProductImagesGallery from "./product-images-gallery";
import ProductReview from "./product-review";
import QuantityControl from "@cbCommerce/admin/components/ui/quantity-control";
import ProductReviewForm from "./product-review-form";
import RelatedProductCarousel from "./related-product-carousel";
import ProductDetailLoading from "./product-detail-loading";
import vSelect from "vue-select";
import WishlistsMixin from "@cbCommerce/mixins/wishlists-mixin";
import SkuQuoteMixin from "@cbCommerce/mixins/sku-quote-mixin";

export default {
  mixins: [WishlistsMixin, SkuQuoteMixin],
  components: {
    StarRating,
    ProductImagesGallery,
    QuantityControl,
    ProductReview,
    ProductReviewForm,
    RelatedProductCarousel,
    ProductDetailLoading,
    vSelect
  },
  data() {
    return {
      chosenQuantity: 1,
      product: null,
      isLoading: false,
      thumbLoadCount: 0,
      productGallery: null,
      productImage: null,
      productImageLarge: null,
      productName: null,
      userPrice: null,
      listPrice: null,
      brand: null,
      model: null,
      features: null,
      details: null,
      totalReviews: null,
      avgRating: null,
      relatedProducts: null,
      activeSkuId: null
    };
  },

  title() {
    return !this.currentProduct
      ? null
      : this.$options.filters.removeHTML(this.currentProduct.name) +
          " | " +
          document.title;
  },

  created: function() {
    this.isLoading = true;
  },

  mounted() {
    this.fetchRelatedProducts();
    this.fetchProductDetail();
    this.getProductReviews(this.productId);
  },

  destroyed() {},

  computed: {
    ...mapState(["globalData"]),
    ...mapGetters([
      "authUser",
      "currentProduct",
      "cartProducts",
      "productsList",
      "productsListArray",
      "currentProductReviews"
    ]),
    isAvailable: function() {
      return this.activeSku.allowBackorder || this.activeSku.onHand;
    },
    availabilityText: function() {
      return this.activeSku.allowBackorder || this.activeSku.onHand
        ? "In Stock"
        : "Out Of Stock";
    },
    productId: () => {
      var locationParts = window.location.pathname.split("/");
      return locationParts[locationParts.length - 1];
    },
    activeSku: function() {
      if (!this.currentProduct) return;
      var self = this;
      let activeSkus = this.currentProduct.skus.filter(
        sku => sku.id === self.activeSkuId
      );
      if (activeSkus.length) return this.currentProduct.skus[0];
    },
    cartTotalPrice: function() {
      if (!this.activeSku) return 0;
      return this.chosenQuantity * this.activeSku.basePrice;
    },
    displayedMedia: function() {
      if (!this.activeSku) return [];
      return this.activeSku.media.concat(this.currentProduct.media);
    }
  },
  methods: {
    ...mapActions([
      "addItemToCart",
      "setCurrentProduct",
      "getListOfProducts",
      "getProductReviews",
      "getProduct",
      "updateProductViews"
    ]),

    // TODO: this can be removed once the API and persistence is in place
    fetchRelatedProducts() {
      const self = this;
      Promise.resolve(this.getListOfProducts({ relatedTo: self.productId }))
        .then(() => {
          self.isLoading = false;
        })
        .catch(err => console.error(err));
    },

    reviewSubmissionReaction: function(reviewData) {
      // Here we would post the review to the API
      // but for now we'll append it to the array for mocking
      this.currentProductReviews.push(reviewData);
    },

    fetchProductDetail: function() {
      var self = this;
      self.isLoading = true;
      self.getProduct(self.productId).then(product => {
        product.skus.forEach((sku, index) => {
          Vue.set(sku, "value", sku.id);
          if (sku.condition.name !== "New") {
            Vue.set(sku, "label", sku.modelNumber + " (Used)");
          } else {
            Vue.set(sku, "label", sku.modelNumber);
          }
        });
        self.setactiveSku(product.skus[0]);
        self.updateProductViews(self.productId);
      });
    },
    setactiveSku(sku) {
      Vue.set(this, "activeSkuId", sku.id);
    },
    selectActiveSku(sku) {
      this.setactiveSku(sku);
      let skus_elements = this.getSKUsElements();
      for (let index = 0; index < skus_elements.length; index++) { 
        this.removeSelectedClass(skus_elements[index].id); 
      } 
      this.addSelectedClass(sku.id);
    },

    quantityChangeReaction: function({ quantity, sku }) {
      if (!quantity) quantity = 1;
      Vue.set(this, "chosenQuantity", quantity);
    },

    addSelectedClass(id) {
      let element = document.getElementById(id);
      element.className += " selected";
    },

    removeSelectedClass(id){
      let element = document.getElementById(id);
      element.classList.remove("selected");
    },
    getSKUsElements(){
      let div = document.getElementById('model-numbers');
      let divs = div.getElementsByClassName('sku-option');
      let divArray = [];
      for (let i = 0; i < divs.length; i += 1) {
        divArray.push(divs[i]);
      }
      return divArray;
    }
  }
};
</script>