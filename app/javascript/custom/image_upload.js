import I18n from 'i18n-js'

document.addEventListener("turbo:load", () => {
  I18n.locale = document.querySelector("body").getAttribute("data-locale");
  document.addEventListener("change", (event) => {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t("microposts.image_size"));
      image_upload.value = "";
    }
  });
});
