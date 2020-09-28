function removeParam(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
        param,
        params_arr = [],
        queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
        params_arr = queryString.split("&");
        for (var i = params_arr.length - 1; i >= 0; i -= 1) {
            param = params_arr[i].split("=")[0];
            if (param === key) {
                params_arr.splice(i, 1);
            }
        }
        rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
}

let getUrlParams = (param) => {
  let url = new URL(window.location.href);
  let p = url.searchParams.get(param);

  return p;
}

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
    if (getUrlParams('input_start') !== null){
      url += `&input_start=${ getUrlParams('input_start') }&input_end=${ getUrlParams('input_end') }`
    }else{
      input_start = '';
      input_end = '';
    }
  }else{
    input_start = $('#filter-input-date').data('daterangepicker').startDate._d;
    input_end = $('#filter-input-date').data('daterangepicker').endDate._d;
    url += `&input_start=${ input_start.toDateTimeString() }&input_end=${ input_end.toDateTimeString() }`
  }

  if ($('#filter-release-date').val().length === 0){
    if (getUrlParams('release_start') !== null){
      url += `&release_start=${ getUrlParams('release_start') }&release_end=${ getUrlParams('release_end') }`
    }else{
    release_start = '';
    release_end = '';
    }
  }else{
    release_start = $('#filter-release-date').data('daterangepicker').startDate._d;
    release_end = $('#filter-release-date').data('daterangepicker').endDate._d;
    url += `&release_start=${ release_start.toDateTimeString() }&release_end=${ release_end.toDateTimeString() }`
  }

  product = $('#filter-products').val();
  if (product.length > 0){
    url += `&products=${ product }`
  }

  return url
}

$(document).ready(function(){
  let filterUrl = '';
  let setDateTime = (target, start, end) => {
    $(target).daterangepicker({
      startDate: moment(start),
      endDate: moment(end),
      timePicker: true,
      autoUpdateInput: false,
      timePickerIncrement: 30,
      locale: {
        format: 'DD/MM/YYYY hh:mm A'
      }
    })

    if (start !== undefined && start.length > 0){
    $(target).val(moment(start).format('DD/MM/YYYY') + ' - ' + moment(end).format('DD/MM/YYYY'));
    }

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

  $('#filter-state').select2();
  $('#filter-products').select2();

  fillUrl('#filter-state', 'change')
  fillUrl('#filter-products', 'change')

  $('#filter-input-date').on('change', function(){
    if ($(this).val() == ''){
      let url = removeParam('input_start', window.location.href)
      window.history.pushState('','', url)
      url = removeParam('input_end', window.location.href)
      window.history.pushState('','', url)
    }
  })

  $('#filter-release-date').on('change', function(){
    if ($(this).val() == ''){
      let url = removeParam('release_start', window.location.href)
      window.history.pushState('','', url)
      url = removeParam('release_end', window.location.href)
      window.history.pushState('','', url)
    }
  })

  $('#submit_filter_product').on('click', function(){
    setFilterUrl();
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
    output += AddZero(this.getMonth() + 1);
    output += AddZero(this.getDate());

    return output;
  }

  function formatDate(date) {
    var d = new Date(date),
      month = '' + (d.getMonth()),
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

  params = ['products', 'state', 'input_start', 'input_end', 'release_start', 'release_end']
  let data = {}

  $.each(params, function (index, value){
    data[value] = getUrlParams(value);
  })

  if (data['products'] !== null && data['products'].length > 0){
    setSelectValue('#filter-products', data['products'].split(','));
  }

  if (data['state'] !== null && data['state'].length > 0){
    setSelectValue('#filter-state', data['state'].split(','));
  }

  if (data['input_start'] !== null && data['end_start'] !== null && data['input_start'].length > 0 ){
    start = new Date(parseInt(data['input_start'].substr(0, 4)), parseInt(data['input_start'].substr(4, 2)), parseInt(data['input_start'].substr(6, 2)))
    end = new Date(parseInt(data['input_end'].substr(0, 4)), parseInt(data['input_end'].substr(4, 2)), parseInt(data['input_end'].substr(6, 2)))
    setDateTime('#filter-input-date', formatDate(start), formatDate(end))
  }else{
    setDateTime('#filter-input-date');
  }

  if (data['release_start'] !== null && data['release_end'] !== null && data['release_start'].length > 0){
    start = new Date(parseInt(data['release_start'].substr(0, 4)), parseInt(data['release_start'].substr(4, 2)), parseInt(data['release_start'].substr(6, 2)))
    end = new Date(parseInt(data['release_end'].substr(0, 4)), parseInt(data['release_end'].substr(4, 2)), parseInt(data['release_end'].substr(6, 2)))
    setDateTime('#filter-release-date', formatDate(start), formatDate(end))
  }else{
    setDateTime('#filter-release-date');
  }
  
})
