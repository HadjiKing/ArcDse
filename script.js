/* ─── script.js ──────────────────────────────────────
   Simo Deco – B2B Furniture Catalog
   Vanilla JS, no dependencies
──────────────────────────────────────────────────── */

(function () {
  'use strict';

  // ────────────────────────────────────────
  // Quote state
  // ────────────────────────────────────────
  const quoteItems = [];

  // ────────────────────────────────────────
  // Navbar – scroll shadow
  // ────────────────────────────────────────
  const navbar = document.getElementById('navbar');
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 30);
  }, { passive: true });

  // ────────────────────────────────────────
  // Active nav link on scroll
  // ────────────────────────────────────────
  const sections = document.querySelectorAll('section[id], footer[id]');
  const navLinks = document.querySelectorAll('.nav-link');

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navLinks.forEach(link => {
          link.classList.toggle('active', link.getAttribute('href') === '#' + entry.target.id);
        });
      }
    });
  }, { threshold: 0.3, rootMargin: '-80px 0px -50% 0px' });

  sections.forEach(sec => observer.observe(sec));

  // ────────────────────────────────────────
  // Mobile hamburger menu
  // ────────────────────────────────────────
  const hamburger = document.getElementById('hamburger');
  const navLinksContainer = document.getElementById('navLinks');

  hamburger.addEventListener('click', () => {
    const isOpen = hamburger.classList.toggle('open');
    navLinksContainer.classList.toggle('open', isOpen);
    hamburger.setAttribute('aria-expanded', String(isOpen));
  });

  // Close mobile menu on link click
  navLinksContainer.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', () => {
      hamburger.classList.remove('open');
      navLinksContainer.classList.remove('open');
    });
  });

  // ────────────────────────────────────────
  // Language Switcher
  // ────────────────────────────────────────
  const langBtn = document.getElementById('langBtn');
  const langDropdown = document.getElementById('langDropdown');
  const langLabel = document.getElementById('langLabel');
  const langFlag = document.getElementById('langFlag');

  langBtn.addEventListener('click', e => {
    e.stopPropagation();
    const isOpen = langDropdown.classList.toggle('open');
    langBtn.setAttribute('aria-expanded', String(isOpen));
  });

  document.addEventListener('click', () => {
    langDropdown.classList.remove('open');
    langBtn.setAttribute('aria-expanded', 'false');
  });

  langDropdown.querySelectorAll('li').forEach(option => {
    option.addEventListener('click', () => {
      langDropdown.querySelectorAll('li').forEach(li => li.classList.remove('active'));
      option.classList.add('active');
      langLabel.textContent = option.dataset.lang.toUpperCase();
      langFlag.textContent = option.dataset.flag;
      langDropdown.classList.remove('open');
      langBtn.setAttribute('aria-expanded', 'false');
      showToast(`Language switched to ${option.textContent.trim()}`);
    });
  });

  // ────────────────────────────────────────
  // Hero Carousel
  // ────────────────────────────────────────
  const slides = document.querySelectorAll('.carousel-slide');
  const dots = document.querySelectorAll('.dot');
  let currentSlide = 0;
  let autoplayTimer = null;

  function goToSlide(index) {
    slides[currentSlide].classList.remove('active');
    dots[currentSlide].classList.remove('active');
    currentSlide = (index + slides.length) % slides.length;
    slides[currentSlide].classList.add('active');
    dots[currentSlide].classList.add('active');
  }

  function startAutoplay() {
    stopAutoplay();
    autoplayTimer = setInterval(() => goToSlide(currentSlide + 1), 4200);
  }

  function stopAutoplay() {
    if (autoplayTimer) clearInterval(autoplayTimer);
  }

  document.getElementById('carouselPrev').addEventListener('click', () => {
    goToSlide(currentSlide - 1);
    startAutoplay();
  });

  document.getElementById('carouselNext').addEventListener('click', () => {
    goToSlide(currentSlide + 1);
    startAutoplay();
  });

  dots.forEach((dot, i) => {
    dot.addEventListener('click', () => {
      goToSlide(i);
      startAutoplay();
    });
  });

  // Touch/swipe support for carousel
  const carouselEl = document.querySelector('.hero-carousel');
  let touchStartX = 0;

  carouselEl.addEventListener('touchstart', e => {
    touchStartX = e.touches[0].clientX;
  }, { passive: true });

  carouselEl.addEventListener('touchend', e => {
    const diff = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 40) {
      goToSlide(diff > 0 ? currentSlide + 1 : currentSlide - 1);
      startAutoplay();
    }
  }, { passive: true });

  startAutoplay();

  // ────────────────────────────────────────
  // Catalog Filter
  // ────────────────────────────────────────
  const filterBtns = document.querySelectorAll('.filter-btn');
  const productCards = document.querySelectorAll('.product-card');

  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const filter = btn.dataset.filter;

      productCards.forEach(card => {
        const categories = card.dataset.category || '';
        if (filter === 'all' || categories.split(' ').includes(filter)) {
          card.classList.remove('hidden');
          // Re-trigger animation
          card.classList.remove('animated');
          requestAnimationFrame(() => {
            requestAnimationFrame(() => card.classList.add('animated'));
          });
        } else {
          card.classList.add('hidden');
        }
      });
    });
  });

  // ────────────────────────────────────────
  // Scroll Animations (IntersectionObserver)
  // ────────────────────────────────────────
  const animatedEls = document.querySelectorAll('[data-animate]');

  const animObserver = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animated');
        animObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12 });

  animatedEls.forEach(el => animObserver.observe(el));

  // ────────────────────────────────────────
  // Product Detail Modal
  // ────────────────────────────────────────
  const productModal = document.getElementById('productModal');

  const productData = {
    'Executive Office Chair': { material: 'Leather & Steel Frame', weight: '14 kg' },
    'Hotel Lobby Chair':      { material: 'Velvet & Gold-plated Metal', weight: '11 kg' },
    'Restaurant Sofa Set':    { material: 'Fabric & Solid Wood', weight: '38 kg' },
    'Mesh Task Chair':        { material: 'Mesh Fabric & Aluminum', weight: '12 kg' },
    'Stackable Metal Chair':  { material: 'Powder-coated Steel', weight: '8 kg' },
    'Executive Wooden Desk':  { material: 'Solid Oak & Steel', weight: '62 kg' },
    'Polycarbonate Chair':    { material: 'Polycarbonate & Chrome Steel', weight: '6 kg' },
    'Bistro Bar Stool':       { material: 'Rattan & Iron Frame', weight: '7 kg' },
    'Conference Table':       { material: 'MDF Veneer & Steel Legs', weight: '80 kg' },
  };

  const tagClass = { office: '', chr: 'chr', metal: 'metal', wood: 'wood', plastic: 'plastic' };

  window.openProductDetail = function (name, imgSrc, category) {
    const data = productData[name] || { material: 'Premium Materials', weight: '10 kg' };
    document.getElementById('modalImg').src = imgSrc;
    document.getElementById('modalImg').alt = name;
    document.getElementById('modalTitle').textContent = name;

    const tag = document.getElementById('modalTag');
    tag.textContent = category.charAt(0).toUpperCase() + category.slice(1);
    tag.className = 'product-tag ' + (tagClass[category] || '');

    document.getElementById('specMaterial').textContent = data.material;
    document.getElementById('specWeight').textContent = data.weight;

    // Reset color & qty
    document.querySelectorAll('.picker-swatches .swatch').forEach((sw, i) => {
      sw.classList.toggle('active', i === 0);
    });
    document.getElementById('colorLabel').textContent = 'Black';
    document.getElementById('qtyInput').value = 10;

    // Store current product name for "Add to Quote"
    productModal.dataset.productName = name;
    productModal.dataset.productCategory = category;
    productModal.classList.add('open');
  };

  // Close modal on overlay click
  productModal.addEventListener('click', e => {
    if (e.target === productModal) productModal.classList.remove('open');
  });

  document.getElementById('quoteModal').addEventListener('click', e => {
    if (e.target === document.getElementById('quoteModal')) {
      document.getElementById('quoteModal').classList.remove('open');
    }
  });

  // Escape key closes modals
  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') {
      productModal.classList.remove('open');
      document.getElementById('quoteModal').classList.remove('open');
    }
  });

  // ────────────────────────────────────────
  // Color Picker
  // ────────────────────────────────────────
  window.selectColor = function (el, colorName) {
    document.querySelectorAll('.picker-swatches .swatch').forEach(s => s.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('colorLabel').textContent = colorName;
  };

  // ────────────────────────────────────────
  // B2B Quantity Selector
  // ────────────────────────────────────────
  window.changeQty = function (delta) {
    const input = document.getElementById('qtyInput');
    const newVal = Math.max(10, (parseInt(input.value, 10) || 10) + delta);
    input.value = newVal;
  };

  // Enforce minimum on manual input
  document.getElementById('qtyInput').addEventListener('change', function () {
    if (parseInt(this.value, 10) < 10 || isNaN(parseInt(this.value, 10))) {
      this.value = 10;
    }
    // Round to nearest 10
    const v = parseInt(this.value, 10);
    this.value = Math.ceil(v / 10) * 10;
  });

  // ────────────────────────────────────────
  // Add to Quote
  // ────────────────────────────────────────
  window.addToQuote = function () {
    const name = productModal.dataset.productName;
    const category = productModal.dataset.productCategory;
    const qty = parseInt(document.getElementById('qtyInput').value, 10);
    const color = document.getElementById('colorLabel').textContent;

    // Check for duplicate
    const existing = quoteItems.find(item => item.name === name && item.color === color);
    if (existing) {
      existing.qty += qty;
      showToast(`Updated "${name}" quantity in your quote`);
    } else {
      quoteItems.push({ name, category, qty, color });
      showToast(`"${name}" added to your quote ✓`);
    }

    updateQuoteBadge();
    renderQuoteList();
    productModal.classList.remove('open');
  };

  function updateQuoteBadge() {
    const badge = document.getElementById('quoteBadge');
    badge.textContent = quoteItems.length;
    badge.classList.add('pop');
    setTimeout(() => badge.classList.remove('pop'), 400);
  }

  function renderQuoteList() {
    const list = document.getElementById('quoteList');
    if (quoteItems.length === 0) {
      list.innerHTML = '<p class="empty-quote">No items yet. Browse the catalog and add products.</p>';
      return;
    }
    list.innerHTML = quoteItems.map((item, idx) => `
      <div class="quote-item">
        <div>
          <div class="quote-item-name">${escapeHtml(item.name)}</div>
          <div class="quote-item-details">${escapeHtml(item.color)} · Qty: ${item.qty}</div>
        </div>
        <button class="quote-item-remove" onclick="removeFromQuote(${idx})" aria-label="Remove item">×</button>
      </div>
    `).join('');
  }

  window.removeFromQuote = function (idx) {
    quoteItems.splice(idx, 1);
    updateQuoteBadge();
    renderQuoteList();
  };

  // ────────────────────────────────────────
  // Quote Form Submit
  // ────────────────────────────────────────
  window.submitQuote = function (e) {
    e.preventDefault();
    // In a real implementation, this would POST to a backend / email API
    showToast('Quote request sent! We\'ll contact you within 24 hours 🎉');
    quoteItems.length = 0;
    updateQuoteBadge();
    renderQuoteList();
    document.getElementById('quoteModal').classList.remove('open');
    document.getElementById('quoteForm').reset();
  };

  // ────────────────────────────────────────
  // Toast Helper
  // ────────────────────────────────────────
  let toastTimer = null;

  function showToast(message) {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.classList.add('show');
    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.remove('show'), 3200);
  }

  // ────────────────────────────────────────
  // HTML Escape (XSS prevention)
  // ────────────────────────────────────────
  function escapeHtml(str) {
    const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
    return String(str).replace(/[&<>"']/g, ch => map[ch]);
  }

  // ────────────────────────────────────────
  // Smooth scroll polyfill for anchor links
  // ────────────────────────────────────────
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        const offset = parseInt(getComputedStyle(document.documentElement)
          .getPropertyValue('--navbar-h'), 10) +
          parseInt(getComputedStyle(document.documentElement)
          .getPropertyValue('--topbar-h'), 10);
        const top = target.getBoundingClientRect().top + window.scrollY - offset;
        window.scrollTo({ top, behavior: 'smooth' });
      }
    });
  });

  // ────────────────────────────────────────
  // Trigger animations for above-the-fold elements
  // ────────────────────────────────────────
  window.addEventListener('load', () => {
    document.querySelectorAll('.hero [data-animate]').forEach(el => {
      setTimeout(() => el.classList.add('animated'), 100);
    });
  });

})();
