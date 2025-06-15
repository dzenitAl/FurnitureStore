using FurnitureStore.Models.SearchObjects;
using FurnitureStore.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.IO;
using FurnitureStore.Services.Database;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.Processing;

namespace FurnitureStore.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductPictureController : BaseCRUDController<Models.ProductPicture.ProductPicture, BaseSearchObject,
        Models.ProductPicture.ProductPictureInsertRequest, Models.ProductPicture.ProductPictureUpdateRequest, long>
    {
        private readonly IWebHostEnvironment _webHostEnvironment;
        private readonly AppDbContext _context;
        private readonly IProductPictureService _productPictureService;
        private readonly ILogger<ProductPictureController> _logger;
        
        private readonly string _imagesDirectory;

        public ProductPictureController(
            ILogger<ProductPictureController> logger, 
            IProductPictureService service,
            IWebHostEnvironment webHostEnvironment,
            AppDbContext context,
            IProductPictureService productPictureService) : base(logger, service)
        {
            _webHostEnvironment = webHostEnvironment;
            _context = context;
            _productPictureService = productPictureService;
            _logger = logger;
            _imagesDirectory = Path.Combine(_webHostEnvironment.WebRootPath, "images");
            
            if (!Directory.Exists(_imagesDirectory))
            {
                Directory.CreateDirectory(_imagesDirectory);
                _logger.LogInformation($"Created images directory at: {_imagesDirectory}");
            }
        }

        [HttpPost("uploadImages")]
        [AllowAnonymous]
        public async Task<IActionResult> UploadProductPictures([FromForm] long productId, [FromForm] List<IFormFile> images)
        {
            try
            {
                if (images == null || !images.Any())
                {
                    return BadRequest("No images provided");
                }

                var results = new List<object>();
                foreach (var image in images)
                {
                    if (image.Length > 0)
                    {
                        var result = await _productPictureService.AddProductPictureAsync(productId, image);
                        results.Add(new { 
                            id = result.Id, 
                            path = result.ImagePath,
                            fullPath = $"{Request.Scheme}://{Request.Host}{result.ImagePath}"
                        });
                    }
                }

                return Ok(new { message = "Images uploaded successfully", results });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error uploading images: {ex.Message}");
                return StatusCode(500, $"Error uploading images: {ex.Message}");
            }
        }

        [HttpGet("GetByProductId/{productId}")]
        public async Task<IActionResult> GetByProductId(long productId)
        {
            if (productId <= 0)
            {
                return BadRequest("Invalid product ID.");
            }

            try
            {
                var pictures = await ((IProductPictureService)_service).GetProductPicturesAsync(productId);
                return Ok(pictures);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Failed to get product pictures: {ex.Message}");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("GetByEntityTypeAndId/{entityType}/{entityId}")]
        public async Task<IActionResult> GetByEntityTypeAndId(string entityType, long entityId)
        {
            if (string.IsNullOrEmpty(entityType) || entityId <= 0)
            {
                return BadRequest("Invalid entity type or ID.");
            }

            try
            {
                var pictures = await _productPictureService.GetAllByEntityAsync(entityType, entityId);
                return Ok(pictures);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Failed to get pictures: {ex.Message}");
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpPost("uploadEntityImages")]
        [AllowAnonymous]
        public async Task<IActionResult> UploadEntityImages(
            [FromForm] string entityType,
            [FromForm] long entityId,
            [FromForm] bool replaceExisting,
            [FromForm] List<IFormFile> images)
        {
            try
            {
                if (images == null || !images.Any())
                {
                    return BadRequest("No images provided");
                }

                var results = new List<object>();
                foreach (var image in images)
                {
                    if (image.Length > 0)
                    {
                        var result = await _productPictureService.AddEntityImageAsync(
                            entityType, 
                            entityId, 
                            image,
                            replaceExisting);
                        results.Add(new { 
                            id = result.Id, 
                            path = result.ImagePath,
                            fullPath = $"{Request.Scheme}://{Request.Host}{result.ImagePath}"
                        });
                    }
                }

                return Ok(new { message = "Images uploaded successfully", results });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error uploading images: {ex.Message}");
                return StatusCode(500, $"Error uploading images: {ex.Message}");
            }
        }

        [HttpGet("folder-check")]
        public IActionResult CheckProductImagesFolder()
        {
            try
            {
                var webRootPath = _webHostEnvironment.WebRootPath;
                var productImagesPath = Path.Combine(webRootPath, "ProductImages");
                
                var folderExists = Directory.Exists(productImagesPath);
                var isWritable = false;
                
                if (folderExists)
                {
                    try
                    {
                        var testFile = Path.Combine(productImagesPath, $"test_{Guid.NewGuid()}.txt");
                        System.IO.File.WriteAllText(testFile, "Test write permission");
                        System.IO.File.Delete(testFile);
                        isWritable = true;
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError($"Folder is not writable: {ex.Message}");
                    }
                }
                else
                {
                    try
                    {
                        Directory.CreateDirectory(productImagesPath);
                        _logger.LogInformation($"Created directory: {productImagesPath}");
                        
                        var testFile = Path.Combine(productImagesPath, $"test_{Guid.NewGuid()}.txt");
                        System.IO.File.WriteAllText(testFile, "Test write permission");
                        System.IO.File.Delete(testFile);
                        isWritable = true;
                        folderExists = true;
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError($"Error creating directory: {ex.Message}");
                    }
                }
                
                return Ok(new
                {
                    WebRootPath = webRootPath,
                    ProductImagesPath = productImagesPath,
                    FolderExists = folderExists,
                    IsWritable = isWritable
                });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error checking folder: {ex.Message}");
                return StatusCode(500, $"Error checking folder: {ex.Message}");
            }
        }

        [HttpGet("test-config")]
        [AllowAnonymous]
        public IActionResult TestConfiguration()
        {
            try
            {
                var webRootPath = _webHostEnvironment.WebRootPath;
                var contentRootPath = _webHostEnvironment.ContentRootPath;
                var productImagesFolder = Path.Combine(contentRootPath, "wwwroot", "ProductImages");
                
                var directoryExists = Directory.Exists(productImagesFolder);
                var isWritable = false;
                
                try
                {
                    var testFile = Path.Combine(productImagesFolder, $"test_{Guid.NewGuid()}.txt");
                    System.IO.File.WriteAllText(testFile, "Test file");
                    System.IO.File.Delete(testFile);
                    isWritable = true;
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Directory not writable: {ex.Message}");
                }
                
                return Ok(new 
                { 
                    WebRootPath = webRootPath,
                    ContentRootPath = contentRootPath,
                    ProductImagesFolder = productImagesFolder,
                    DirectoryExists = directoryExists,
                    IsWritable = isWritable,
                    OSDescription = System.Runtime.InteropServices.RuntimeInformation.OSDescription,
                    FrameworkDescription = System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error checking configuration: {ex.Message}");
            }
        }

        [HttpGet("test-save")]
        [AllowAnonymous]
        public IActionResult TestSaveFile()
        {
            try
            {
                var contentRootPath = _webHostEnvironment.ContentRootPath;
                var productImagesFolder = Path.Combine(contentRootPath, "wwwroot", "ProductImages");
                
                if (!Directory.Exists(productImagesFolder))
                {
                    Directory.CreateDirectory(productImagesFolder);
                }
                
                var testFileName = $"test_{Guid.NewGuid()}.txt";
                var testFilePath = Path.Combine(productImagesFolder, testFileName);
                
                System.IO.File.WriteAllText(testFilePath, "This is a test file created at " + DateTime.Now.ToString());
                
                return Ok(new 
                { 
                    Success = true,
                    FilePath = testFilePath,
                    WebPath = $"/ProductImages/{testFileName}"
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Success = false,
                    Error = ex.Message,
                    InnerError = ex.InnerException?.Message,
                    StackTrace = ex.StackTrace
                });
            }
        }

        [HttpGet("direct-file-test")]
        public IActionResult DirectFileTest()
        {
            try
            {
                var webRootPath = _webHostEnvironment.WebRootPath;
                var contentRootPath = _webHostEnvironment.ContentRootPath;
                var webRootImagesPath = Path.Combine(webRootPath, "images");
                var contentRootImagesPath = Path.Combine(contentRootPath, "images");
                var wwwrootImagesPath = Path.Combine(contentRootPath, "wwwroot", "images");
                
                _logger.LogInformation($"WebRootPath: {webRootPath}");
                _logger.LogInformation($"ContentRootPath: {contentRootPath}");
                
                Directory.CreateDirectory(webRootImagesPath);
                Directory.CreateDirectory(contentRootImagesPath);
                Directory.CreateDirectory(wwwrootImagesPath);
                
                var testContent = $"Test file created at {DateTime.Now}";
                var testGuid = Guid.NewGuid().ToString();
                var webRootTestFile = Path.Combine(webRootImagesPath, $"test_webroot_{testGuid}.txt");
                var contentRootTestFile = Path.Combine(contentRootImagesPath, $"test_contentroot_{testGuid}.txt");
                var wwwrootTestFile = Path.Combine(wwwrootImagesPath, $"test_wwwroot_{testGuid}.txt");
                
                System.IO.File.WriteAllText(webRootTestFile, testContent);
                System.IO.File.WriteAllText(contentRootTestFile, testContent);
                System.IO.File.WriteAllText(wwwrootTestFile, testContent);
                
                var absoluteImagesDir = Path.Combine(contentRootPath, "wwwroot", "images");
                if (!Directory.Exists(absoluteImagesDir))
                {
                    Directory.CreateDirectory(absoluteImagesDir);
                }
                
                var absoluteTestFile = Path.Combine(absoluteImagesDir, $"test_absolute_{testGuid}.txt");
                System.IO.File.WriteAllText(absoluteTestFile, testContent);
                
                return Ok(new
                {
                    Message = "Test files created successfully",
                    WebRootTestFile = webRootTestFile,
                    ContentRootTestFile = contentRootTestFile,
                    WwwrootTestFile = wwwrootTestFile,
                    AbsoluteTestFile = absoluteTestFile,
                    WebRootPath = webRootPath,
                    ContentRootPath = contentRootPath,
                    WebRootImagesPath = webRootImagesPath,
                    ContentRootImagesPath = contentRootImagesPath,
                    WwwrootImagesPath = wwwrootImagesPath,
                    AbsoluteImagesPath = absoluteImagesDir,
                    TestUrls = new
                    {
                        WebRootUrl = $"/images/test_webroot_{testGuid}.txt",
                        WwwrootUrl = $"/images/test_wwwroot_{testGuid}.txt",
                        AbsoluteUrl = $"/images/test_absolute_{testGuid}.txt"
                    }
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new
                {
                    Error = ex.Message,
                    StackTrace = ex.StackTrace
                });
            }
        }

        [HttpGet("direct-image/{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetImageById(long id, [FromQuery] int? width = null)
        {
            try
            {
                var productPicture = await _productPictureService.GetProductPictureById(id);
                if (productPicture == null)
                {
                    return NotFound($"Image with ID {id} not found");
                }

                string imagePath = productPicture.ImagePath;
                if (imagePath.StartsWith("/"))
                {
                    imagePath = imagePath.Substring(1);
                }

                string fullPath = Path.Combine(_webHostEnvironment.WebRootPath, imagePath);
                
                if (!System.IO.File.Exists(fullPath))
                {
                    _logger.LogError($"Image file not found at path: {fullPath}");
                    return NotFound($"Image file not found for ID {id}");
                }

                if (width.HasValue)
                {
                    using (var image = Image.Load(fullPath))
                    {
                        var ratio = (double)image.Height / image.Width;
                        var height = (int)(width.Value * ratio);

                        image.Mutate(x => x.Resize(width.Value, height));

                        using (var ms = new MemoryStream())
                        {
                            image.Save(ms, new JpegEncoder { Quality = 80 });
                            ms.Position = 0;
                            return File(ms.ToArray(), "image/jpeg");
                        }
                    }
                }

                string contentType = GetContentType(fullPath);
                return PhysicalFile(fullPath, contentType);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error serving image: {ex.Message}");
                return StatusCode(500, $"Error serving image: {ex.Message}");
            }
        }

        private string GetContentType(string path)
        {
            string extension = Path.GetExtension(path).ToLowerInvariant();
            return extension switch
            {
                ".jpg" or ".jpeg" => "image/jpeg",
                ".png" => "image/png",
                ".gif" => "image/gif",
                _ => "application/octet-stream"
            };
        }
    }
}
