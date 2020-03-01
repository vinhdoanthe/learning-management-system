(async () => {
    // const url = 'http://localhost:3000/learning/test_send_pdf_data';
    // var pdfAsArray = convertDataURIToBinary(pdfAsDataUri);
    // PDFJS.getDocument(pdfAsArray)
    // const loadingTask = PDFJS.getDocument(url);
    // const pdf = await loadingTask.promise;

    // Load information from the first page.
    const page = await pdf.getPage(1);

    const scale = 1;
    const viewport = page.getViewport(scale);

    // Apply page dimensions to the <canvas> element.
    const canvas = document.getElementById("pdf");
    const context = canvas.getContext("2d");
    canvas.height = viewport.height;
    canvas.width = viewport.width;

    // Render the page into the <canvas> element.
    const renderContext = {
        canvasContext: context,
        viewport: viewport
    };
    await page.render(renderContext);
    console.log("Page rendered!");
})();


function convertDataURIToBinary(dataURI) {
    var base64Index = dataURI.indexOf(BASE64_MARKER) + BASE64_MARKER.length;
    var base64 = dataURI.substring(base64Index);
    var raw = window.atob(base64);
    var rawLength = raw.length;
    var array = new Uint8Array(new ArrayBuffer(rawLength));

    for(var i = 0; i < rawLength; i++) {
        array[i] = raw.charCodeAt(i);
    }
    return array;
}