// ==========================================
// SIMO DECO - Main JavaScript
// ==========================================

document.addEventListener('DOMContentLoaded', () => {

  // ---- NAVBAR SCROLL ----
  const navbar = document.getElementById('navbar');
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 30);
    updateScrollTop();
  });

  // ---- HAMBURGER / MOBILE MENU ----
  const hamburger = document.getElementById('hamburger');
  const mobileMenu = document.getElementById('mobile-menu');
  hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('open');
    mobileMenu.classList.toggle('open');
  });
  mobileMenu.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => {
      hamburger.classList.remove('open');
      mobileMenu.classList.remove('open');
    });
  });

  // ---- LANGUAGE SWITCHER ----
  const langBtn  = document.getElementById('lang-btn');
  const langDrop = document.getElementById('lang-dropdown');
  langBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const isOpen = langDrop.classList.toggle('open');
    langBtn.classList.toggle('open', isOpen);
  });
  langDrop.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', (e) => {
      e.preventDefault();
      const flag = a.querySelector('.flag').textContent;
      const lang = a.querySelector('.lang-code').textContent;
      langBtn.querySelector('.flag').textContent = flag;
      langBtn.querySelector('.lang-code').textContent = lang;
      langDrop.classList.remove('open');
      langBtn.classList.remove('open');
    });
  });
  document.addEventListener('click', () => {
    langDrop.classList.remove('open');
    langBtn.classList.remove('open');
  });

  // ---- QUOTE COUNTER ----
  let quoteCount = 0;
  const quoteCountEl = document.getElementById('quote-count');
  function addToQuote() {
    quoteCount++;
    quoteCountEl.textContent = quoteCount;
    quoteCountEl.classList.remove('bump');
    void quoteCountEl.offsetWidth; // reflow
    quoteCountEl.classList.add('bump');
    showToast('✅ Product added to your quote!');
  }
  window.addToQuote = addToQuote;

  // ---- TOAST ----
  const toast = document.getElementById('toast');
  let toastTimer;
  function showToast(msg) {
    toast.querySelector('.toast-msg').textContent = msg;
    toast.classList.add('show');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.remove('show'), 3000);
  }

  // ---- HERO SLIDER ----
  const slides    = document.querySelectorAll('.slide');
  const dots      = document.querySelectorAll('.slider-dot');
  let currentSlide = 0;
  let sliderTimer;

  function goToSlide(idx) {
    slides[currentSlide].classList.remove('active');
    dots[currentSlide].classList.remove('active');
    currentSlide = (idx + slides.length) % slides.length;
    slides[currentSlide].classList.add('active');
    dots[currentSlide].classList.add('active');
  }

  function nextSlide() { goToSlide(currentSlide + 1); }
  function prevSlide() { goToSlide(currentSlide - 1); }

  function startSlider() {
    clearInterval(sliderTimer);
    sliderTimer = setInterval(nextSlide, 3500);
  }

  document.getElementById('slider-next').addEventListener('click', () => { nextSlide(); startSlider(); });
  document.getElementById('slider-prev').addEventListener('click', () => { prevSlide(); startSlider(); });
  dots.forEach((dot, i) => dot.addEventListener('click', () => { goToSlide(i); startSlider(); }));

  goToSlide(0);
  startSlider();

  // ---- CATALOG FILTER ----
  const filterBtns = document.querySelectorAll('.filter-btn');
  const productCards = document.querySelectorAll('.product-card');

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const filter = btn.dataset.filter;
      productCards.forEach(card => {
        if (filter === 'all' || card.dataset.category === filter) {
          card.classList.remove('hidden');
        } else {
          card.classList.add('hidden');
        }
      });
    });
  });

  // ---- PRODUCT SWATCHES (card) ----
  document.querySelectorAll('.product-card .swatch').forEach(sw => {
    sw.addEventListener('click', (e) => {
      e.stopPropagation();
      const card = sw.closest('.product-card');
      card.querySelectorAll('.swatch').forEach(s => s.classList.remove('active'));
      sw.classList.add('active');
    });
  });

  // ---- VIEW DETAILS BUTTON ----
  document.querySelectorAll('.btn-view').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const section = document.getElementById('product-details');
      section.scrollIntoView({ behavior: 'smooth' });
    });
  });

  // ---- PD COLOR SWATCHES ----
  const colorSwatches = document.querySelectorAll('.swatch-lg');
  const colorSelected = document.querySelector('.color-selected');
  colorSwatches.forEach(sw => {
    sw.addEventListener('click', () => {
      colorSwatches.forEach(s => s.classList.remove('active'));
      sw.classList.add('active');
      if (colorSelected) colorSelected.textContent = sw.dataset.name;
    });
  });

  // ---- PD QUANTITY ----
  const qtyInput = document.getElementById('qty-input');
  const MIN_QTY = 10;
  document.getElementById('qty-minus').addEventListener('click', () => {
    const val = parseInt(qtyInput.value) || MIN_QTY;
    if (val > MIN_QTY) qtyInput.value = val - 1;
  });
  document.getElementById('qty-plus').addEventListener('click', () => {
    const val = parseInt(qtyInput.value) || MIN_QTY;
    qtyInput.value = val + 1;
  });
  qtyInput.addEventListener('change', () => {
    const val = parseInt(qtyInput.value) || MIN_QTY;
    qtyInput.value = Math.max(MIN_QTY, val);
  });

  // ---- PD THUMBNAILS ----
  document.querySelectorAll('.pd-thumb').forEach(thumb => {
    thumb.addEventListener('click', () => {
      document.querySelectorAll('.pd-thumb').forEach(t => t.classList.remove('active'));
      thumb.classList.add('active');
    });
  });

  // ---- ADD TO QUOTE (PD) ----
  const addQuoteBtn = document.getElementById('add-to-quote');
  if (addQuoteBtn) {
    addQuoteBtn.addEventListener('click', addToQuote);
  }

  // ---- SCROLL TO TOP ----
  const scrollTopBtn = document.getElementById('scroll-top');
  function updateScrollTop() {
    scrollTopBtn.classList.toggle('visible', window.scrollY > 400);
  }
  scrollTopBtn.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  // ---- ACTIVE NAV LINK (intersection observer) ----
  const sections = document.querySelectorAll('section[id]');
  const navLinks  = document.querySelectorAll('.nav-links a[href^="#"], .mobile-menu a[href^="#"]');
  const io = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navLinks.forEach(a => {
          a.classList.toggle('active', a.getAttribute('href') === '#' + entry.target.id);
        });
      }
    });
  }, { rootMargin: '-40% 0px -55% 0px' });
  sections.forEach(s => io.observe(s));

  // ---- ANIMATED COUNTERS (features) ----
  const counters = document.querySelectorAll('.count-up');
  const counterIO = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        counterIO.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });
  counters.forEach(el => counterIO.observe(el));

  function animateCounter(el) {
    const target = parseInt(el.dataset.target);
    const suffix = el.dataset.suffix || '';
    const dur    = 1500;
    const step   = dur / 60;
    let current  = 0;
    const increment = target / (dur / step);
    const timer = setInterval(() => {
      current += increment;
      if (current >= target) {
        current = target;
        clearInterval(timer);
      }
      el.textContent = Math.floor(current) + suffix;
    }, step);
  }

});
