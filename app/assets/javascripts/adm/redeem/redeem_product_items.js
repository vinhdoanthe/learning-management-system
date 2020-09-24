let filterProducts = (data) => {
  $.ajax({
    method: "GET",
    url: "/adm/redeem/redeem_products",
    data: data
  })
}

let fillUrl = (target, event) => {
  $(target).on(event, function(){
    filterUrl = setFilterUrl();
    if (!filterUrl.includes('?')){
      filterUrl = '?' + filterUrl
    }

    window.history.pushState('','', filterUrl)

  })
}

let setFilterUrl = () => {
  url = ''

  state = $('#filter-state').val();
  if (state.length > 0){
    url += `&state=${ state }`
  }

  if ($('#filter-input-date').val().length === 0){
    input_start = '';
    input_end = '';
  }else{
    input_start = $('#filter-input-date').data('daterangepicker').startDate._d;
    input_end = $('#filter-input-date').data('daterangepicker').endDate._d;
    url += `&input_start=${ input_start.toDateTimeString() }&input_end=${ input_end.toDateTimeString() }`
  }

  if ($('#filter-release-date').val().length === 0){
    release_start = '';
    release_end = '';
  }else{
    release_start = $('#filter-release-date').data('daterangepicker').startDate._d;
    release_end = $('#filter-release-date').data('daterangepicker').endDate._d;
    url += `&release_start=${ release_start.toDateTimeString() }&release_end=${ release_end.toDateTimeString() }`
  }

  product = $('#filter-products').val();
  if (product.length > 0){
    url += `&products=${ product }`
  }
  localStorage.setItem('state', state)
  localStorage.setItem('input_start', input_start)
  localStorage.setItem('input_end', input_end)
  localStorage.setItem('release_start', release_start)
  localStorage.setItem('release_end', release_end)
  localStorage.setItem('product', product)

  return url
}

$(document).ready(function(){
  let filterUrl = '';
  let setDateTime = (target, start, end) => {
    $(target).daterangepicker({
      startDate: start,
      endDate: end,
      timePicker: true,
      autoUpdateInput: false,
      timePickerIncrement: 30,
      locale: {
        format: 'DD/MM/YYYY hh:mm A'
      }
    })

    $(target).on('apply.daterangepicker', function(ev, picker) {
      $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
      url = setFilterUrl();
      if (!url.includes('?')){
        url = '?' + url
      }
      window.history.pushState('','', url)
    });

    $(target).on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
      url = setFilterUrl();
      if (!url.includes('?')){
        url = '?' + url
      }
      window.history.pushState('','', url)
    }); 
  }

  setDateTime('#filter-input-date');
  setDateTime('#filter-release-date');
  $('#filter-state').select2();
  $('#filter-products').select2();

  fillUrl('#filter-state', 'change')
  fillUrl('#filter-products', 'change')

  $('#submit_filter_product').on('click', function(){
    window.open(window.location.href, "_self")
  })

  Date.prototype.toDateTimeString = function () {
    //If month/day is single digit value add perfix as 0
    function AddZero(obj) {
      obj = obj + '';
      if (obj.length == 1)
        obj = "0" + obj
      return obj;
    }

    var output = "";
    output += this.getFullYear();
    output += AddZero(this.getMonth()+1);
    output += AddZero(this.getDate());

    return output;
  }

  function formatDate(date) {
    var d = new Date(date),
      month = '' + (d.getMonth() + 1),
      day = '' + d.getDate(),
      year = d.getFullYear();

    if (month.length < 2)
      month = '0' + month;
    if (day.length < 2)
      day = '0' + day;

    return [year, month, day].join('-');
  }

  let setSelectValue = (target, arr_val) => {
    $(target).val(arr_val).trigger('change');
  }

  let setDatePickerValue = (target, start, end) => {
    $(target).daterangepicker({ startDate: moment(start), endDate: moment(end), locale: { format: 'DD/MM/YYYY' } });
  }

  let setFilterParamsFromLocalStorage = () => {
    products = localStorage.getItem("product");
    if (products != null && products.length > 0){
      setSelectValue('#filter-products', products.split(','));
    }

    states = localStorage.getItem("state");
    if (states != null && states.length > 0){
      setSelectValue('#filter-state', states.split(','));
    }

    input_start = localStorage.getItem("input_start");
    input_end = localStorage.getItem("input_end");
    if (input_start != null && input_start.length > 0){
      start = new Date(input_start);
      end = new Date(input_end);
      setDateTime('#filter-input-date', formatDate(start), formatDate(end))
    }

    release_start = localStorage.getItem("input_start");
    release_end = localStorage.getItem("input_end");
    if (release_start != null && input_start.length > 0){
      start = new Date(release_start);
      end = new Date(release_end);
      setDateTime('#filter-release-date', formatDate(start), formatDate(end))
    }
  }


  setFilterParamsFromLocalStorage();
  window.onunload = () => {
    window.MyStorage.clear()
  }

})
