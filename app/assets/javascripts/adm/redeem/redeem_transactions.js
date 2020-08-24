$(document).ready(() => {
  $('.btn-cancel-transaction').click((event) => {
    event.preventDefault();
    let transaction_id = $(event.currentTarget).data('transaction-id');
    show_cancel_confirm_modal(transaction_id);
  })

  $('.btn-approve-transaction').click((event) => {
    event.preventDefault();
    let transaction_id = $(event.currentTarget).data('transaction-id');
    show_approve_confirm_modal(transaction_id);
  })

  $('.btn-complete-transaction').click((event) => {
    event.preventDefault();
    let transaction_id = $(event.currentTarget).data('transaction-id');
    show_complete_confirm_modal(transaction_id);
  })

  $('.btn-confirm-cancel-transaction').click((event) => {
    let transaction_id = $('#cancelTransactionBody').data('transaction-id');
    let reason_cancel = tinymce.get("reasonCancel").getContent();

    if (transaction_id && reason_cancel) {
      cancel_transaction(transaction_id, reason_cancel);
    } else {
      alert('Error! Transaction and Reason can not be blank!')
    }
  })

  $('.btn-confirm-approve-transaction').click((event) => {
    let transaction_id = $('#approveTransactionBody').data('transaction-id');
    let note = tinymce.get("noteApprove").getContent();

    if (transaction_id) {
      approve_transaction(transaction_id, note)
    } else {
      alert('Error! Transaction can not be blank!')
    }
  })

  $('.btn-confirm-complete-transaction').click((event) => {
    let transaction_id = $('#completeTransactionBody').data('transaction-id');
    let note = tinymce.get("noteComplete").getContent();

    if (transaction_id) {
      complete_transaction(transaction_id, note);
    } else {
      alert('Error! Transaction can not be blank!');
    }
  })
})

let show_cancel_confirm_modal = (transaction_id) => {
  $("#cancelTransactionBody").html(`
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
  `);
  $("#cancelTransactionModal").modal('show');
  get_transaction(transaction_id, 'cancel');
}

let show_approve_confirm_modal = (transaction_id) => {
  $("#approveTransactionBody").html(`
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
  `);
  $("#approveTransactionModal").modal('show');
  get_transaction(transaction_id, 'approve');
}

let show_complete_confirm_modal = (transaction_id) => {
  $("#completeTransactionBody").html(`
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
  `);
  $("#completeTransactionModal").modal('show');
  get_transaction(transaction_id, 'complete');
}

let get_transaction = (transaction_id, mode) => {
  $.ajax({
    url: '/adm/redeem/redeem_transactions/show/' + transaction_id + '?mode=' + mode,
    type: "GET",
    dataType: 'script',
  })
}

var cancel_transaction = (transaction_id, reason_cancel) => {
  $.ajax({
    url: '/adm/redeem/redeem_transactions/cancel/' + transaction_id,
    type: "POST",
    dataType: 'json',
    data: {
      note: reason_cancel
    },

    success: (response) => {
      if (response.success) {
        $('#cancelTransactionModal').modal('hide');
        location.reload(); 
        toastr.success('Cancel transaction success!');
        // update elements
        // let row_id_status = "#transaction-row-" + response.transaction_id + " > .transaction-status"
        // let row_id_note = "#transaction-row-" + response.transaction_id + " > .transaction-note"
        // let row_id_actions = "#transaction-row-" + response.transaction_id + " > .transaction-actions"

        // $(row_id_status).html(response.transaction_status);

        // $(row_id_note).html(response.note)

        // $(row_id_actions).html(`
        //   <a class="btn btn-info" href="${response.show_url}">view</a>
        // `);
      } else{
        $('#cancelTransactionModal').modal('hide');
        toastr.error('Cancel transaction failed!');
      }
    },

    error: (response) => {
      $('#cancelTransactionModal').modal('hide');
      toastr.error('Cancel transaction failed!');
    }
  })
}

var approve_transaction = (transaction_id, note) => {
  $.ajax({
    url: '/adm/redeem/redeem_transactions/approve/' + transaction_id,
    type: "POST",
    dataType: 'json',
    data: {
      note: note
    },
    success: (response) => {
      if (response.success) {
        $('#approveTransactionModal').modal('hide');
        location.reload();
        toastr.success("Approve transaction successfully!");

        // Update UI elements
        // let row_id_status = "#transaction-row-" + response.transaction_id + " > .transaction-status"
        // let row_id_note = "#transaction-row-" + response.transaction_id + " > .transaction-note"
        // let row_id_actions = "#transaction-row-" + response.transaction_id + " > .transaction-actions"

        // $(row_id_status).html(response.transaction_status);

        // $(row_id_note).html(response.note)

        // $(row_id_actions).html(`
        //   <a class="btn btn-info" href="${response.show_url}">view</a>
        //   <a class="btn btn-danger btn-cancel-transaction" data-transaction-id="${response.transaction_id}" href="#">Cancel</a>
        //   <a class="btn btn-success btn-complete-transaction" data-transaction-id="${response.transaction_id}" href="#">Complete</a>
        // `)
      } else {
        $("#approveTransactionModal").modal("hide");
        toastr.error('Approve transaction failed!')
      } 
    },
    error: (response) => {
      $("#approveTransactionModal").modal("hide");
      toastr.error('Approve transaction failed!')
    }
  })
}

var complete_transaction = (transaction_id, note) => {
  $.ajax({
    url: '/adm/redeem/redeem_transactions/complete/' + transaction_id,
    type: "POST",
    dataType: 'json',
    data: {
      note: note,
    },
    success: (response) => {
      if (response.success) {
        console.log(response);
        console.log('success')
        $('#completeTransactionModal').modal('hide');
        location.reload();
        toastr.success('Complete transaction success!');

        // update elements
        // let row_id_status = "#transaction-row-" + response.transaction_id + " > .transaction-status"
        // let row_id_note = "#transaction-row-" + response.transaction_id + " > .transaction-note"
        // let row_id_actions = "#transaction-row-" + response.transaction_id + " > .transaction-actions"

        // $(row_id_status).html(response.transaction_status);

        // $(row_id_note).html(response.note)

        // $(row_id_actions).html(`
        //   <a class="btn btn-info" href="${response.show_url}">view</a>
        // `);
      } else {
        console.log(response);
        $('#completeTransactionModal').modal('hide');
        toastr.error('Complete transaction failed!');
      }
    },
    error: (response) => {
      console.log(response);
      $('#completeTransactionModal').modal('hide');
      toastr.error('Complete transaction failed!');
    }
  })
}
